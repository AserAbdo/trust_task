import 'package:flutter/material.dart';

/// Custom home icon for bottom navigation
class HomeNavIcon extends StatelessWidget {
  final bool isSelected;

  const HomeNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    return CustomPaint(
      size: const Size(26, 26),
      painter: _HomeIconPainter(
        color: isSelected ? darkBrown : greyColor,
        isSelected: isSelected,
      ),
    );
  }
}

class _HomeIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  _HomeIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw house shape
    final path = Path();
    // Roof
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.1, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.9);
    path.lineTo(size.width * 0.75, size.height * 0.9);
    path.lineTo(size.width * 0.75, size.height * 0.45);
    path.lineTo(size.width * 0.9, size.height * 0.45);
    path.close();

    canvas.drawPath(path, paint);

    // Draw door
    if (isSelected) {
      final doorPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.55,
          size.width * 0.2,
          size.height * 0.35,
        ),
        doorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
