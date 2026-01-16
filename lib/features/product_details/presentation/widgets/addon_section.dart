import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_details.dart';

class AddonSection extends StatelessWidget {
  final ProductAddon addon;
  final List<String> selectedOptions;
  final Function(String, bool) onOptionToggle;
  final int index;

  const AddonSection({
    super.key,
    required this.addon,
    required this.selectedOptions,
    required this.onOptionToggle,
    required this.index,
  });

  String _getSandwichLabel(BuildContext context, int index) {
    final l10n = context.l10n;
    switch (index) {
      case 0:
        return l10n.translate('first_sandwich');
      case 1:
        return l10n.translate('second_sandwich');
      case 2:
        return l10n.translate('third_sandwich');
      default:
        return addon.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isRadio =
        addon.type.toLowerCase() == 'radio' ||
        addon.type.toLowerCase() == 'radiobutton';
    final title =
        addon.name.contains('sandwich') || addon.name.contains('سندوتش')
        ? _getSandwichLabel(context, index)
        : addon.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (addon.options.isNotEmpty)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          ...addon.options.map((option) {
            final isSelected = selectedOptions.contains(option.label);
            return _buildOptionTile(context, option, isSelected, isRadio, l10n);
          }),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    AddonOption option,
    bool isSelected,
    bool isRadio,
    AppLocalizations l10n,
  ) {
    return InkWell(
      onTap: () => onOptionToggle(option.label, isRadio),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (isRadio)
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) {
                  if (value != null) onOptionToggle(option.label, isRadio);
                },
                activeColor: AppTheme.primaryColor,
              )
            else
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  onOptionToggle(option.label, isRadio);
                },
                activeColor: AppTheme.primaryColor,
              ),
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (double.tryParse(option.price) != null &&
                double.tryParse(option.price)! > 0)
              Text(
                '+${option.price} ${l10n.translate('currency_symbol')}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
