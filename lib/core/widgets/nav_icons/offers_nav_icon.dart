import 'package:flutter/material.dart';

/// Custom offers icon for bottom navigation
class OffersNavIcon extends StatelessWidget {
  final bool isSelected;

  const OffersNavIcon({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    return Icon(
      isSelected ? Icons.local_offer : Icons.local_offer_outlined,
      color: isSelected ? darkBrown : greyColor,
      size: 26,
    );
  }
}
