import 'package:flutter/material.dart';

/// Custom account icon for bottom navigation
class AccountNavIcon extends StatelessWidget {
  final bool isSelected;

  const AccountNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    return CustomPaint(
      size: const Size(28, 28),
      painter: _AccountIconPainter(color: isSelected ? darkBrown : greyColor),
    );
  }
}

class _AccountIconPainter extends CustomPainter {
  final Color color;

  _AccountIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Draw outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw head (small circle)
    final headRadius = size.width * 0.12;
    final headCenter = Offset(center.dx, center.dy - size.height * 0.08);
    canvas.drawCircle(headCenter, headRadius, paint);

    // Draw body (arc at bottom)
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final bodyPath = Path();
    bodyPath.moveTo(
      center.dx - size.width * 0.18,
      center.dy + size.height * 0.28,
    );
    bodyPath.quadraticBezierTo(
      center.dx - size.width * 0.18,
      center.dy + size.height * 0.08,
      center.dx,
      center.dy + size.height * 0.08,
    );
    bodyPath.quadraticBezierTo(
      center.dx + size.width * 0.18,
      center.dy + size.height * 0.08,
      center.dx + size.width * 0.18,
      center.dy + size.height * 0.28,
    );

    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
