import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/cart.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  // Colors matching the design
  static const Color linenColor = Color(0xFFFAF0E6);
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Main row with image, details, and controls
          Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              _buildProductImage(),
              const SizedBox(width: 12),

              // Middle: Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.getLocalizedName(l10n.locale.languageCode),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: darkBrown,
                      ),
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      _formatPrice(item.itemTotal, l10n),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: darkBrown,
                      ),
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Quantity controls
              _buildQuantityControls(context),
            ],
          ),

          // Addons section (if any)
          if (item.addons.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildAddonsSection(context, l10n, isArabic),
          ],
        ],
      ),
    );
  }

  String _formatPrice(double price, AppLocalizations l10n) {
    final currencySymbol = l10n.translate('currency_symbol');
    final formattedPrice = price.toStringAsFixed(2);

    if (l10n.isArabic) {
      return '$formattedPrice $currencySymbol';
    } else {
      return '$currencySymbol $formattedPrice';
    }
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease/Delete button
          GestureDetector(
            onTap: item.quantity > 1 ? onDecrement : onRemove,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: redColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                color: redColor,
                size: 20,
              ),
            ),
          ),

          // Quantity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkBrown,
              ),
            ),
          ),

          // Plus button
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: redColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: item.productImage != null
            ? CachedNetworkImage(
                imageUrl: item.productImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: redColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.fastfood_rounded,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              )
            : Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.fastfood_rounded,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
      ),
    );
  }

  Widget _buildAddonsSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Addons label
        Text(
          l10n.translate('addons'),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkBrown,
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        // Addons list with separators
        Row(
          mainAxisAlignment: isArabic
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: _buildAddonChips(isArabic),
        ),
      ],
    );
  }

  List<Widget> _buildAddonChips(bool isArabic) {
    List<Widget> chips = [];
    for (int i = 0; i < item.addons.length; i++) {
      // Use Arabic name if available and in Arabic mode
      final addonName = isArabic
          ? (item.addons[i].nameAr ?? item.addons[i].name)
          : item.addons[i].name;

      chips.add(
        Text(
          addonName,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      );
      // Add separator between addons
      if (i < item.addons.length - 1) {
        chips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '|',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ),
        );
      }
    }
    return chips;
  }
}
