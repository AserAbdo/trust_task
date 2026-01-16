import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// A reusable back button widget with Arabic text "رجوع" and an arrow.
/// Matches the design from the Figma mockups.
class CustomBackButton extends StatelessWidget {
  /// Optional callback when button is pressed. Defaults to Navigator.pop()
  final VoidCallback? onPressed;

  /// Button text color
  final Color textColor;

  /// Arrow icon color
  final Color iconColor;

  /// Background color of the button
  final Color backgroundColor;

  /// Border color of the button
  final Color borderColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.textColor = const Color(0xFF4A4A4A),
    this.iconColor = const Color(0xFF4A4A4A),
    this.backgroundColor = Colors.transparent,
    this.borderColor = const Color(0xFFD0D0D0),
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arrow pointing right (arrow_back shows right arrow)
            Icon(Icons.arrow_back, size: 30, color: iconColor),
            const SizedBox(width: 8),
            // Arabic text "رجوع"
            Text(
              l10n.translate('back'),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
