import 'dart:ui';
import 'package:flutter/material.dart';

/// A custom blurred divider widget that can be used globally across the app.
/// This creates a subtle, blurry line separator effect.
class BlurredDivider extends StatelessWidget {
  /// Height of the divider line
  final double height;

  /// Color of the divider
  final Color color;

  /// Horizontal padding around the divider
  final double horizontalPadding;

  /// Blur intensity (sigma value)
  final double blurSigma;

  const BlurredDivider({
    super.key,
    this.height = 1.5,
    this.color = Colors.black26,
    this.horizontalPadding = 20,
    this.blurSigma = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
