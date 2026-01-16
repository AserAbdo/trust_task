import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/blurred_divider.dart';
import '../../domain/entities/product_details.dart';

class AddonSection extends StatelessWidget {
  final ProductAddon addon;
  final List<String> selectedOptions;
  final Function(String, bool) onOptionToggle;
  final int index;
  final bool showDivider;

  // Colors
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  const AddonSection({
    super.key,
    required this.addon,
    required this.selectedOptions,
    required this.onOptionToggle,
    required this.index,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = l10n.locale.languageCode;

    // Use localized name based on current language
    final title = addon.getLocalizedName(languageCode);

    // Radio if not multi-choice
    final isRadio = !addon.isMultiChoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Title - aligned based on language direction
        Align(
          alignment: l10n.isArabic
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: l10n.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: darkBrown,
                ),
                textDirection: l10n.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
              if (addon.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: redColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Options List
        ...addon.options.map((option) {
          final isSelected = selectedOptions.contains(option.label);
          return _buildOptionTile(context, option, isSelected, isRadio, l10n);
        }),

        // Divider between addons with blur effect
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: BlurredDivider(horizontalPadding: 0),
          ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    AddonOption option,
    bool isSelected,
    bool isRadio,
    AppLocalizations l10n,
  ) {
    // Use localized label based on current language
    final displayLabel = option.getLocalizedLabel(l10n.locale.languageCode);

    return InkWell(
      onTap: () => onOptionToggle(option.label, isRadio),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          textDirection: l10n.isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Radio/Checkbox
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: isRadio ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isRadio ? null : BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? redColor : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected
                    ? (isRadio ? Colors.white : redColor)
                    : Colors.white,
              ),
              child: isRadio
                  ? Center(
                      child: isSelected
                          ? Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: redColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    )
                  : isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),

            // Option Label
            Expanded(
              child: Text(
                displayLabel,
                style: TextStyle(fontSize: 17, color: Colors.grey.shade700),
                textDirection: l10n.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ),

            // Price if > 0
            if (_hasPrice(option.price))
              Text(
                '+${option.price}',
                style: const TextStyle(
                  fontSize: 15,
                  color: redColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _hasPrice(String price) {
    if (price.isEmpty || price == '0') return false;
    final priceValue = double.tryParse(price);
    return priceValue != null && priceValue > 0;
  }
}
