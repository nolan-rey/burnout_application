import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

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

class _AppBottomNavBarState extends State<AppBottomNavBar> with TickerProviderStateMixin {
  FragmentProgram? _program;
  
  late Ticker _timeTicker;
  double _time = 0.0;
  
  late AnimationController _springController;
  final ValueNotifier<double> _bubbleX = ValueNotifier(-1.0);
  double _bubbleWidth = 64.0;
  double _lastBubbleX = 0;
  
  double _navBarWidth = 0.0;
  double _itemWidth = 0.0;
  final double _baseBubbleSize = 64.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
    
    // Ticker continu pour le shader et la physique d'étirement organique
    _timeTicker = createTicker((elapsed) {
      _time = elapsed.inMicroseconds / 1000000.0;
      
      // -- Logique d'étirement (Stretching) --
      if (_lastBubbleX != 0 && !_isDragging) {
         double velocity = (_bubbleX.value - _lastBubbleX).abs();
         // Vitesse max d'environ 15px par frame. On demande un étirement proportionnel.
         double targetWidth = _baseBubbleSize + (velocity * 2.5); // Étirement visqueux
         
         // Lissage de la taille pour un rendu naturel de bulle de savon liquide
         _bubbleWidth += (targetWidth - _bubbleWidth) * 0.15;
      } else if (_isDragging) {
         _bubbleWidth += (_baseBubbleSize - _bubbleWidth) * 0.2;
      } else {
         _bubbleWidth += (_baseBubbleSize - _bubbleWidth) * 0.1;
      }
      _lastBubbleX = _bubbleX.value;

      if (mounted && _program != null) {
        setState(() {}); 
      }
    });
    _timeTicker.start();

    _springController = AnimationController.unbounded(vsync: this);
    _springController.addListener(() {
      _bubbleX.value = _springController.value;
    });
  }

  Future<void> _loadShader() async {
    try {
      _program = await FragmentProgram.fromAsset('shaders/liquid_glass.frag');
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Failed to load liquid_glass shader: $e");
    }
  }

  @override
  void didUpdateWidget(AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && oldWidget.currentIndex != widget.currentIndex && _itemWidth > 0) {
      _snapToNearestIndex();
    }
  }

  @override
  void dispose() {
    _timeTicker.dispose();
    _springController.dispose();
    _bubbleX.dispose();
    super.dispose();
  }

  double _calcXForIndex(int index) {
    return (index * _itemWidth) + (_itemWidth / 2) - (_baseBubbleSize / 2);
  }

  void _snapToNearestIndex() {
    final targetX = _calcXForIndex(widget.currentIndex);
    
    final spring = SpringSimulation(
      const SpringDescription(mass: 1.0, stiffness: 180, damping: 16),
      _bubbleX.value == -1.0 ? targetX : _bubbleX.value,
      targetX,
      0, 
    );
    
    _springController.animateWith(spring);
  }

  void _handleDrag(DragUpdateDetails details) {
    _isDragging = true;
    _springController.stop();
    
    double newX = details.localPosition.dx - (_baseBubbleSize / 2);
    newX = newX.clamp(4.0, _navBarWidth - _baseBubbleSize - 4.0);
    _bubbleX.value = newX;
    
    int hoveredIndex = ((details.localPosition.dx) / _itemWidth).floor().clamp(0, 4);
    if (hoveredIndex != widget.currentIndex) {
      widget.onTap(hoveredIndex);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    _snapToNearestIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _navBarWidth = constraints.maxWidth;
          _itemWidth = _navBarWidth / 5;
          
          if (_bubbleX.value == -1.0 && _itemWidth > 0) {
            _bubbleX.value = _calcXForIndex(widget.currentIndex);
            _lastBubbleX = _bubbleX.value;
          }

          // L'arrière-plan de la NavyBar englobe TOUT
          return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22).withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // --- SHADER ORGANIQUE: La Goutte ---
                    if (_program != null)
                      ValueListenableBuilder<double>(
                        valueListenable: _bubbleX,
                        builder: (context, xPos, child) {
                           // Centrage vertical
                           final yPos = (80 - _baseBubbleSize) / 2;
                           // Si la bulle s'étire en largeur, on doit ajuster la position X pour l'ancrer
                           // afin qu'elle s'étire vers le centre du mouvement 
                           // (mais Spring le gère plutôt bien tel quel)
                           
                           return CustomPaint(
                             size: Size(_navBarWidth, 80),
                             painter: LiquidGlassPainter(
                               shader: _program!.fragmentShader(),
                               time: _time,
                               xPos: xPos,
                               yPos: yPos,
                               width: _bubbleWidth,
                               height: _baseBubbleSize,
                             ),
                           );
                        },
                      ),

                    // --- ICÔNES ---
                    GestureDetector(
                      onPanStart: (details) => _handleDrag(DragUpdateDetails(
                        globalPosition: details.globalPosition, 
                        localPosition: details.localPosition,
                      )),
                      onPanUpdate: _handleDrag,
                      onPanEnd: _handleDragEnd,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          _buildNavItem(0, Icons.home_rounded, 'Accueil'),
                          _buildNavItem(1, Icons.calendar_month_rounded, 'Agenda'),
                          _buildNavItem(2, Icons.dynamic_feed_rounded, 'Feed'),
                          _buildNavItem(3, Icons.people_alt_rounded, 'Coach'),
                          _buildNavItem(4, Icons.person_rounded, 'Profil'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _itemWidth,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 26,
                color: isActive ? Colors.white : AppColors.textMuted.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiquidGlassPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final double xPos;
  final double yPos;
  final double width;
  final double height;

  LiquidGlassPainter({
    required this.shader,
    required this.time,
    required this.xPos,
    required this.yPos,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, width);
    shader.setFloat(1, height);
    shader.setFloat(2, xPos);
    shader.setFloat(3, yPos);
    shader.setFloat(4, time);

    final paint = Paint()
      ..shader = shader
      // Par défaut BlendMode.srcOver. 
      ..isAntiAlias = true;
    
    // Le Correctif de la Goutte Noire / Coupure Rectangulaire :
    // Au lieu d'utiliser canvas.drawRect et de demander au Shader GLSL de cacher
    // les bords via une condition (ce qui donne un fond noir sur certains rendus),
    // nous traçons directement une forme OVALE parfait (RRect) via l'API vectorielle
    // de Flutter. Le shader va remplir exactement l'intérieur fluide de cette Pilule.
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(xPos, yPos, width, height),
      Radius.circular(height / 2.0),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidGlassPainter oldDelegate) {
    return true; // Rafraîchissement 60/120fps continu
  }
}
