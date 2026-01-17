import 'package:flutter/material.dart';

/// Custom menu icon for bottom navigation
class MenuNavIcon extends StatelessWidget {
  final bool isSelected;

  const MenuNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    // Fixed size container to prevent any movement
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? darkBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              Icons.menu_book_rounded,
              color: isSelected ? Colors.white : greyColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
