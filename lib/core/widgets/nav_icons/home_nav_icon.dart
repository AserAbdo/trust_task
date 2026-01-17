import 'package:flutter/material.dart';

/// Custom home icon for bottom navigation - Rounded house with door detail
class HomeNavIcon extends StatelessWidget {
  final bool isSelected;

  const HomeNavIcon({super.key, required this.isSelected});

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
        painter: _HomeIconPainter(color: color, isFilled: isSelected),
      ),
    );
  }
}

class _HomeIconPainter extends CustomPainter {
  final Color color;
  final bool isFilled;

  _HomeIconPainter({required this.color, required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Draw rounded house shape
    final path = Path();

    // Start from top left of the vertical wall
    path.moveTo(w * 0.15, h * 0.45);

    // Roof (more triangular)
    path.quadraticBezierTo(
      w * 0.15,
      h * 0.35, // Control point
      w * 0.25,
      h * 0.25, // End of curve
    );

    path.lineTo(w * 0.42, h * 0.10); // Left slope

    // Top peak (rounded)
    path.quadraticBezierTo(
      w * 0.5,
      h * 0.04, // Control point
      w * 0.58,
      h * 0.10, // End of curve
    );

    path.lineTo(w * 0.75, h * 0.25); // Right slope

    path.quadraticBezierTo(
      w * 0.85,
      h * 0.35, // Control point
      w * 0.85,
      h * 0.45, // End of curve
    );

    // Right wall
    path.lineTo(w * 0.85, h * 0.82);

    // Bottom right corner
    path.quadraticBezierTo(w * 0.85, h * 0.95, w * 0.7, h * 0.95);

    // Bottom floor
    path.lineTo(w * 0.3, h * 0.95);

    // Bottom left corner
    path.quadraticBezierTo(w * 0.15, h * 0.95, w * 0.15, h * 0.82);

    path.close();

    canvas.drawPath(path, paint);

    // Draw small vertical door/handle
    final doorPaint = Paint()
      ..color = isFilled ? Colors.white : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.5, h * 0.68),
      Offset(w * 0.5, h * 0.82),
      doorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HomeIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isFilled != isFilled;
  }
}
