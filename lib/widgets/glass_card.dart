import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final Border? border;
  final VoidCallback? onTap;
  final double blurStrength;
  final double opacity;
  final Color? glowColor;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.color,
    this.border,
    this.onTap,
    this.blurStrength = 20,
    this.opacity = 1.0,
    this.glowColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          if (glowColor != null)
            BoxShadow(
              color: glowColor!.withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ?? AppColors.liquidGlassGradient,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border(
                top: BorderSide(
                  color: AppColors.glassHighlight,
                  width: 0.8,
                ),
                left: BorderSide(
                  color: AppColors.glassBorder,
                  width: 0.5,
                ),
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.03),
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
