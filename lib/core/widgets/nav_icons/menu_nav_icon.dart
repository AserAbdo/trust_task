import 'package:flutter/material.dart';

/// Custom menu icon for bottom navigation
class MenuNavIcon extends StatelessWidget {
  final bool isSelected;

  const MenuNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    // Fixed size container to prevent movement
    return SizedBox(
      width: 36,
      height: 36,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(isSelected ? 6 : 0),
          decoration: BoxDecoration(
            color: isSelected ? darkBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.menu_book_rounded : Icons.menu_book_outlined,
            color: isSelected ? Colors.white : greyColor,
            size: isSelected ? 20 : 24,
          ),
        ),
      ),
    );
  }
}
