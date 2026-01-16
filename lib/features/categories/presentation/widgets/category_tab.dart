import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? emoji;
  final IconData? icon;

  const CategoryTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.emoji,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const Color redColor = Color(0xFFE53935);
    const Color lightPink = Color(0xFFFFE4E1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? redColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? redColor : lightPink,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji or Icon
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(icon, color: isSelected ? Colors.white : redColor, size: 16),
              const SizedBox(width: 6),
            ],
            // Label
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : redColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
