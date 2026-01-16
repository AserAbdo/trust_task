import 'package:flutter/material.dart';

/// Custom menu icon for bottom navigation
class MenuNavIcon extends StatelessWidget {
  final bool isSelected;

  const MenuNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: darkBrown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.menu_book_rounded,
          color: Colors.white,
          size: 20,
        ),
      );
    }

    return Icon(Icons.menu_book_outlined, color: greyColor, size: 26);
  }
}
