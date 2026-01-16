import 'package:flutter/material.dart';

/// Custom shopping bag painter with a smiley face
class ShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Bag body
    final bagPath = Path();
    bagPath.moveTo(w * 0.15, h * 0.35);
    bagPath.lineTo(w * 0.15, h * 0.85);
    bagPath.quadraticBezierTo(w * 0.15, h * 0.95, w * 0.25, h * 0.95);
    bagPath.lineTo(w * 0.75, h * 0.95);
    bagPath.quadraticBezierTo(w * 0.85, h * 0.95, w * 0.85, h * 0.85);
    bagPath.lineTo(w * 0.85, h * 0.35);
    canvas.drawPath(bagPath, paint);

    // Bag handles
    final handlePath = Path();
    handlePath.moveTo(w * 0.30, h * 0.35);
    handlePath.quadraticBezierTo(w * 0.30, h * 0.15, w * 0.50, h * 0.15);
    handlePath.quadraticBezierTo(w * 0.70, h * 0.15, w * 0.70, h * 0.35);
    canvas.drawPath(handlePath, paint);

    // Smile
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(w * 0.35, h * 0.60);
    smilePath.quadraticBezierTo(w * 0.50, h * 0.75, w * 0.65, h * 0.60);
    canvas.drawPath(smilePath, smilePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.38, h * 0.50), 2.5, eyePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.50), 2.5, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
