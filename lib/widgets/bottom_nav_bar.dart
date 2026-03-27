import 'dart:ui';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
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

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  double _dragX = -1; // -1 indicates no active drag

  void _handleDrag(DragUpdateDetails details, double itemWidth, double maxW) {
    setState(() {
      _dragX = details.localPosition.dx.clamp(0.0, maxW);
    });
    int newIndex = (_dragX / itemWidth).floor().clamp(0, 4);
    if (newIndex != widget.currentIndex) {
      widget.onTap(newIndex);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() => _dragX = -1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double navBarWidth = constraints.maxWidth - 32;
        final double itemWidth = navBarWidth / 5;
        const double bubbleWidth = 72.0;
        const double bubbleHeight = 60.0;
        
        // Compute bubble position
        final double targetLeft = (itemWidth * widget.currentIndex) + (itemWidth / 2) - (bubbleWidth / 2);
        final double currentLeft = _dragX >= 0 ? _dragX - (bubbleWidth / 2) : targetLeft;
        
        // Clamp the visual left so it doesn't overflow the pill
        final double clampedLeft = currentLeft.clamp(4.0, navBarWidth - bubbleWidth - 4.0);

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              // Blur the entire navbar background a bit to make it glassy
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22).withValues(alpha: 0.85), // Dark pill background
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // The moving liquid glass bubble
                    AnimatedPositioned(
                      duration: _dragX >= 0 
                        ? const Duration(milliseconds: 50)  // Fast follow while dragging
                        : const Duration(milliseconds: 400), // Spring back/tap animation
                      curve: _dragX >= 0 ? Curves.linear : Curves.easeOutBack,
                      left: clampedLeft,
                      top: 10,
                      child: _buildLiquidBubble(bubbleWidth, bubbleHeight),
                    ),

                    // Gesture detector and icons row
                    GestureDetector(
                      onPanStart: (details) => _handleDrag(DragUpdateDetails(globalPosition: details.globalPosition, localPosition: details.localPosition), itemWidth, navBarWidth),
                      onPanUpdate: (details) => _handleDrag(details, itemWidth, navBarWidth),
                      onPanEnd: _handleDragEnd,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          _buildNavItem(0, Icons.home_rounded, 'Accueil', itemWidth),
                          _buildNavItem(1, Icons.calendar_month_rounded, 'Agenda', itemWidth),
                          _buildNavItem(2, Icons.dynamic_feed_rounded, 'Feed', itemWidth),
                          _buildNavItem(3, Icons.people_alt_rounded, 'Coach', itemWidth),
                          _buildNavItem(4, Icons.person_rounded, 'Profil', itemWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiquidBubble(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        // Subtle outer drop shadow to separate it slightly
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: BackdropFilter(
          // True glass blur that distorts the background underneath
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              // Very faint white tint to act as the glass body
              color: Colors.white.withValues(alpha: 0.04),
              // Simple, clean white border for the reflection
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.0,
              ),
              // Gentle white/transparent gradient for light reflection (NO COLORS)
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2), // Top-left highlight
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.05), // Bottom-right reflection
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, double width) {
    final isActive = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
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
                // Explicitly white when active, muted gray when inactive (like Revolut)
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
