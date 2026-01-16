import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/blurred_divider.dart';

class CartSummary extends StatefulWidget {
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
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  // Colors matching the design
  static const Color linenColor = Color(0xFFFAF0E6);
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  late TextEditingController _couponController;
  bool _hasCouponText = false;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController(text: widget.couponCode);
    _hasCouponText = _couponController.text.isNotEmpty;
    _couponController.addListener(_onCouponTextChanged);
  }

  @override
  void dispose() {
    _couponController.removeListener(_onCouponTextChanged);
    _couponController.dispose();
    super.dispose();
  }

  void _onCouponTextChanged() {
    final hasText = _couponController.text.isNotEmpty;
    if (hasText != _hasCouponText) {
      setState(() {
        _hasCouponText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: linenColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coupon input row
          _buildCouponRow(l10n, isArabic),

          const SizedBox(height: 24),

          // Payment details section
          _buildPaymentDetailsSection(l10n, isArabic),
        ],
      ),
    );
  }

  Widget _buildCouponRow(AppLocalizations l10n, bool isArabic) {
    return Row(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      children: [
        // Coupon text field with trash icon inside
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: Row(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Text input
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: const TextStyle(fontSize: 16, color: darkBrown),
                    decoration: InputDecoration(
                      hintText: l10n.translate('enter_coupon'),
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        right: isArabic ? 20 : 8,
                        left: isArabic ? 8 : 20,
                      ),
                    ),
                  ),
                ),
                // Trash icon inside the input
                GestureDetector(
                  onTap: () {
                    _couponController.clear();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isArabic ? 16 : 0,
                      right: isArabic ? 0 : 16,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey.shade400,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Apply button - changes color based on text
        GestureDetector(
          onTap: () => widget.onApplyCoupon(_couponController.text),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: _hasCouponText
                  ? redColor // Red when has text (same as checkout)
                  : const Color(0xFFE8D5D0), // Beige when empty
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.translate('apply'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _hasCouponText ? Colors.white : darkBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsSection(AppLocalizations l10n, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: linenColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: isArabic
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Title - aligned based on language
          Align(
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              l10n.translate('payment_details'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: darkBrown,
              ),
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
          const SizedBox(height: 16),

          // Blurred divider
          const BlurredDivider(horizontalPadding: 0),
          const SizedBox(height: 16),

          // Subtotal row
          _buildSummaryRow(
            l10n.translate('subtotal'),
            _formatPrice(widget.subtotal, l10n),
            isArabic,
          ),
          const SizedBox(height: 8),

          // Dashed divider
          _buildDashedDivider(),
          const SizedBox(height: 8),

          // Tax row
          _buildSummaryRow(
            l10n.translate('tax'),
            _formatPrice(widget.tax, l10n),
            isArabic,
          ),
          const SizedBox(height: 8),

          // Dashed divider
          _buildDashedDivider(),
          const SizedBox(height: 8),

          // Total row (bold and larger)
          _buildSummaryRow(
            l10n.translate('total_amount'),
            _formatPrice(widget.total, l10n),
            isArabic,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price, AppLocalizations l10n) {
    final currencySymbol = l10n.translate('currency_symbol');
    final formattedPrice = price.toStringAsFixed(2);

    // For Arabic, currency comes after. For English, currency comes before.
    if (l10n.isArabic) {
      return '$formattedPrice $currencySymbol';
    } else {
      return '$currencySymbol $formattedPrice';
    }
  }

  /// Builds a dashed divider line
  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (index) {
            return Container(
              width: dashWidth,
              height: 1,
              color: Colors.grey.shade300,
            );
          }),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isArabic, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? darkBrown : Colors.grey.shade600,
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
        // Value
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? redColor : darkBrown,
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
      ],
    );
  }
}
