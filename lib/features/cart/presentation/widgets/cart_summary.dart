import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;
  final String? couponCode;
  final Function(String) onApplyCoupon;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.couponCode,
    required this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final couponController = TextEditingController(text: couponCode);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: couponController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: l10n.translate('enter_coupon'),
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.receipt_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => onApplyCoupon(couponController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: AppTheme.textPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.translate('apply')),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  l10n.translate('payment_details'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  context,
                  l10n.translate('subtotal'),
                  '${subtotal.toStringAsFixed(2)} ${l10n.translate('currency_symbol')}',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  context,
                  l10n.translate('tax'),
                  '${tax.toStringAsFixed(2)} ${l10n.translate('currency_symbol')}',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _buildSummaryRow(
                  context,
                  l10n.translate('total_amount'),
                  '${total.toStringAsFixed(2)} ${l10n.translate('currency_symbol')}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppTheme.textSecondary,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
