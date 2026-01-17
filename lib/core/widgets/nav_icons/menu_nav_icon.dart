import 'package:flutter/material.dart';

/// Custom menu icon for bottom navigation - Open book with lines style
class MenuNavIcon extends StatelessWidget {
  final bool isSelected;

  const MenuNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    final color = isSelected ? darkBrown : greyColor;

    // Fixed size container to prevent any movement
    return SizedBox(
      width: 28,
      height: 24,
      child: CustomPaint(
        size: const Size(28, 24),
        painter: _MenuBookPainter(color: color),
      ),
    );
  }
}

/// Custom painter for the open book menu icon
class _MenuBookPainter extends CustomPainter {
  final Color color;

  _MenuBookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Left page
    final leftPage = Path()
      ..moveTo(size.width * 0.48, size.height * 0.15)
      ..lineTo(size.width * 0.05, size.height * 0.08)
      ..lineTo(size.width * 0.05, size.height * 0.85)
      ..lineTo(size.width * 0.48, size.height * 0.92)
      ..close();

    canvas.drawPath(leftPage, paint);

    // Right page
    final rightPage = Path()
      ..moveTo(size.width * 0.52, size.height * 0.15)
      ..lineTo(size.width * 0.95, size.height * 0.08)
      ..lineTo(size.width * 0.95, size.height * 0.85)
      ..lineTo(size.width * 0.52, size.height * 0.92)
      ..close();

    canvas.drawPath(rightPage, paint);

    // Lines on left page (white lines for text effect)
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Line 1 on left page
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.32),
      Offset(size.width * 0.40, size.height * 0.35),
      linePaint,
    );

    // Line 2 on left page
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.50),
      Offset(size.width * 0.40, size.height * 0.53),
      linePaint,
    );

    // Line 3 on left page
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.68),
      Offset(size.width * 0.40, size.height * 0.71),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MenuBookPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
