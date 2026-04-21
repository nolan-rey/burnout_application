import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Bottom navigation "Liquid Glass".
///
/// Architecture anti-coupure :
///   1) Un SEUL BackdropFilter flou englobe toute la navbar (pill continu).
///   2) Un SEUL CustomPainter dessine : le fond teinté + la bulle metaball
///      en courbes de Bézier + le shader GLSL en mode additif pour le rim
///      iridescent et le highlight.
///   3) Les icônes sont posées PAR DESSUS en Stack, mais n'appliquent aucun
///      clip ni fond opaque -> aucun rectangle sombre ne peut apparaître.
///
/// La bulle est un PATH organique : la largeur, les tangentes Bézier et
/// l'asymétrie gauche/droite dépendent de la vélocité du spring -> effet
/// de goutte de mercure qui s'étire réellement pendant le mouvement.
class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  static const int _itemCount = 5;
  static const double _barHeight = 80;
  static const double _bubbleW = 72;
  static const double _bubbleH = 60;

  ui.FragmentProgram? _program;

  late final AnimationController _spring;
  double _pos = 0; // index continu (0..4)
  double _vel = 0; // vitesse lissée pour la déformation

  late final Ticker _clock;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _pos = widget.currentIndex.toDouble();

    _spring = AnimationController.unbounded(vsync: this)
      ..addListener(() {
        setState(() {
          _pos = _spring.value;
          _vel = _spring.velocity;
        });
      });

    _clock = createTicker((elapsed) {
      setState(() => _time = elapsed.inMicroseconds / 1e6);
    })..start();

    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final p = await ui.FragmentProgram.fromAsset('shaders/liquid_glass.frag');
      if (mounted) setState(() => _program = p);
    } catch (_) {/* fallback visuel dans le painter */}
  }

  @override
  void didUpdateWidget(covariant AppBottomNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _spring.animateWith(SpringSimulation(
        const SpringDescription(mass: 1.0, stiffness: 180, damping: 16),
        _pos,
        widget.currentIndex.toDouble(),
        _vel,
      ));
    }
  }

  @override
  void dispose() {
    _spring.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barW = constraints.maxWidth - 32;
        final double itemW = barW / _itemCount;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          height: _barHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_barHeight / 2),
            // UN SEUL BackdropFilter -> fond flouté continu, aucune coupure.
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Fond + bulle metaball + shader dans UN SEUL painter.
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: _LiquidNavPainter(
                        position: _pos,
                        velocity: _vel,
                        itemWidth: itemW,
                        bubbleSize: const Size(_bubbleW, _bubbleH),
                        time: _time,
                        program: _program,
                      ),
                    ),
                  ),

                  // Icônes — transparentes, aucun fond, aucun clip.
                  Row(
                    children: [
                      _item(0, Icons.home_rounded, 'Accueil', itemW),
                      _item(1, Icons.calendar_month_rounded, 'Agenda', itemW),
                      _item(2, Icons.dynamic_feed_rounded, 'Feed', itemW),
                      _item(3, Icons.people_alt_rounded, 'Coach', itemW),
                      _item(4, Icons.person_rounded, 'Profil', itemW),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _item(int index, IconData icon, String label, double w) {
    final double d = (index - _pos).abs().clamp(0.0, 1.0);
    final double activeness = 1.0 - d; // 1 sur l'onglet actif, 0 au voisin
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: w,
        height: _barHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.0 + 0.08 * activeness,
              child: Icon(
                icon,
                size: 26,
                color: Color.lerp(
                  AppColors.textMuted.withValues(alpha: 0.6),
                  Colors.white,
                  activeness,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    activeness > 0.5 ? FontWeight.w700 : FontWeight.w500,
                color: Color.lerp(
                  AppColors.textMuted.withValues(alpha: 0.7),
                  Colors.white,
                  activeness,
                ),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  PAINTER — fond + bulle Bézier + shader, sans clip rectangulaire.
// ---------------------------------------------------------------------------

class _LiquidNavPainter extends CustomPainter {
  final double position; // index continu
  final double velocity; // unités = index/s
  final double itemWidth;
  final Size bubbleSize;
  final double time;
  final ui.FragmentProgram? program;

  _LiquidNavPainter({
    required this.position,
    required this.velocity,
    required this.itemWidth,
    required this.bubbleSize,
    required this.time,
    required this.program,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1) Fond pill teinté — un seul drawRRect qui couvre TOUTE la navbar.
    //    On garde un alpha modéré pour laisser le flou du BackdropFilter
    //    parent respirer. Aucun sous-rectangle ailleurs.
    final pill = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height / 2),
    );
    final bgPaint = Paint()
      ..color = const Color(0xFF161B22).withValues(alpha: 0.55);
    canvas.drawRRect(pill, bgPaint);

    // Liseré supérieur (reflet de haut, style verre).
    final rimTop = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height),
        [
          Colors.white.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.0),
        ],
      );
    canvas.drawRRect(pill, rimTop);

    // 2) Position/déformation de la bulle.
    final double cx =
        itemWidth * position + itemWidth / 2; // centre X de la bulle
    final double cy = size.height / 2;

    // Étirement proportionnel à |vitesse|, signé pour la direction.
    final double speed = velocity.abs().clamp(0.0, 8.0);
    final double stretch = speed * 10.0; // px ajoutés à la largeur
    final double squash = speed * 0.6;   // px soustraits à la hauteur
    final double dir = velocity.sign;     // -1 / 0 / +1
    final double trail = speed * 6.0;     // traînée asymétrique

    final double w = bubbleSize.width + stretch;
    final double h = (bubbleSize.height - squash).clamp(32.0, bubbleSize.height);

    final Rect bbox = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

    // 3) Path metaball : superellipse asymétrique en courbes de Bézier.
    //    L'avant (sens du mouvement) est arrondi, l'arrière s'étire en traîne.
    final Path bubble = _buildBubblePath(bbox, dir, trail);

    // 4) Halo externe doux (glow). Dessiné AVANT la bulle pour rester
    //    derrière le corps translucide.
    final halo = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawPath(bubble, halo);

    // 5) Corps de la bulle : translucide — on NE peint PAS un fond opaque.
    //    Une très légère teinte blanche + shader additif par dessus.
    final body = Paint()..color = Colors.white.withValues(alpha: 0.06);
    canvas.drawPath(bubble, body);

    // 6) Shader GLSL : rim iridescent + highlight, en mode additif.
    if (program != null) {
      final shader = program!.fragmentShader();
      shader.setFloat(0, bbox.width);
      shader.setFloat(1, bbox.height);
      shader.setFloat(2, time);
      shader.setFloat(3, 0.9); // chroma
      shader.setFloat(4, 1.0); // glow

      final shaderPaint = Paint()
        ..shader = shader
        ..blendMode = BlendMode.plus; // additif -> jamais de coupure sombre

      canvas.save();
      canvas.translate(bbox.left, bbox.top);
      // On clippe au path bulle (pas un rectangle) pour que l'iridescence
      // suive la forme organique.
      canvas.clipPath(bubble.shift(-bbox.topLeft));
      canvas.drawRect(Offset.zero & bbox.size, shaderPaint);
      canvas.restore();
    } else {
      // Fallback sans shader : bord blanc subtil.
      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white.withValues(alpha: 0.35);
      canvas.drawPath(bubble, border);
    }

    // 7) Liseré fin toujours visible pour le contour du verre.
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.22);
    canvas.drawPath(bubble, edge);
  }

  /// Construit une forme de goutte organique via 4 courbes cubiques.
  /// Les tangentes sont modulées par `dir` et `trail` pour créer
  /// l'étirement directionnel (mercure).
  Path _buildBubblePath(Rect r, double dir, double trail) {
    final double cx = r.center.dx;
    final double cy = r.center.dy;
    final double rx = r.width / 2;
    final double ry = r.height / 2;

    // Décalage du centre vers la direction du mouvement -> asymétrie.
    final double bias = dir * trail * 0.25;

    // 4 points cardinaux (N, E, S, W).
    final Offset n = Offset(cx + bias, cy - ry);
    final Offset e = Offset(cx + rx + bias * 0.3, cy);
    final Offset s = Offset(cx + bias, cy + ry);
    final Offset w = Offset(cx - rx + bias * 0.3, cy);

    // Magnitude des tangentes (superellipse -> ovale lisse).
    const double k = 0.5523; // approximation du cercle avec cubiques
    final double kx = rx * k;
    final double ky = ry * k;

    // Asymétrie : l'avant (selon dir) a des tangentes plus longues
    // -> arrondi ; l'arrière plus courtes -> traîne pointue.
    final double frontBoost = 1.0 + 0.35 * trail / 40.0;
    final double backBoost  = 1.0 - 0.25 * trail / 40.0;
    final double kxFront = kx * (dir >= 0 ? frontBoost : backBoost);
    final double kxBack  = kx * (dir >= 0 ? backBoost  : frontBoost);

    final path = Path()
      ..moveTo(n.dx, n.dy)
      // N -> E
      ..cubicTo(
        n.dx + kxFront, n.dy,
        e.dx, e.dy - ky,
        e.dx, e.dy,
      )
      // E -> S
      ..cubicTo(
        e.dx, e.dy + ky,
        s.dx + kxFront, s.dy,
        s.dx, s.dy,
      )
      // S -> W
      ..cubicTo(
        s.dx - kxBack, s.dy,
        w.dx, w.dy + ky,
        w.dx, w.dy,
      )
      // W -> N
      ..cubicTo(
        w.dx, w.dy - ky,
        n.dx - kxBack, n.dy,
        n.dx, n.dy,
      )
      ..close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _LiquidNavPainter old) =>
      old.position != position ||
      old.velocity != velocity ||
      old.time != time ||
      old.program != program;
}
