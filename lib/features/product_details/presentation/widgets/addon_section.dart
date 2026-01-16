import 'package:flutter/material.dart';
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
    // Use Arabic name if available, otherwise use the English name
    final title = addon.displayName;

    // Radio if not multi-choice
    final isRadio = !addon.isMultiChoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Title - RTL aligned, large and bold
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: darkBrown,
                ),
                textDirection: TextDirection.rtl,
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
          return _buildOptionTile(context, option, isSelected, isRadio);
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
  ) {
    // Use Arabic label if available
    final displayLabel = option.displayLabel;

    return InkWell(
      onTap: () => onOptionToggle(option.label, isRadio),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          textDirection: TextDirection.rtl,
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
                textDirection: TextDirection.rtl,
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
