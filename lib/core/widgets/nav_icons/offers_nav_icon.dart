import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom offers icon for bottom navigation - Discount badge with percent sign
class OffersNavIcon extends StatelessWidget {
  final bool isSelected;

  const OffersNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    final color = isSelected ? darkBrown : greyColor;

    return SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(
        size: const Size(26, 26),
        painter: _OffersBadgePainter(color: color, isFilled: isSelected),
      ),
    );
  }
}

/// Custom painter for the discount badge icon with percent sign
class _OffersBadgePainter extends CustomPainter {
  final Color color;
  final bool isFilled;

  _OffersBadgePainter({required this.color, required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    // Create zigzag/starburst path
    final path = Path();
    const int points = 12;
    const double innerRadiusRatio = 0.75;

    for (int i = 0; i < points * 2; i++) {
      final double angle = (i * math.pi / points) - math.pi / 2;
      final double r = i.isEven ? radius : radius * innerRadiusRatio;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Draw the badge outline or filled
    final paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawPath(path, paint);

    // Draw percent sign
    final percentColor = isFilled ? Colors.white : color;
    final percentPaint = Paint()
      ..color = percentColor
      ..style = PaintingStyle.fill;

    final strokePercentPaint = Paint()
      ..color = percentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Top circle of percent
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.12, center.dy - size.height * 0.12),
      size.width * 0.08,
      percentPaint,
    );

    // Bottom circle of percent
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.12, center.dy + size.height * 0.12),
      size.width * 0.08,
      percentPaint,
    );

    // Diagonal line of percent
    canvas.drawLine(
      Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.15),
      Offset(center.dx - size.width * 0.15, center.dy + size.height * 0.15),
      strokePercentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OffersBadgePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isFilled != isFilled;
  }
}
