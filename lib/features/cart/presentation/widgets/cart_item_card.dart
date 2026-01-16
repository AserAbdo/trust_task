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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Main row with image, details, and controls - RTL direction
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right side (in RTL): Product image
              _buildProductImage(),
              const SizedBox(width: 12),

              // Middle: Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.productName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: darkBrown,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      '${l10n.translate('currency_symbol')} ${item.itemTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: darkBrown,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Left side (in RTL): Quantity controls
              _buildQuantityControls(context),
            ],
          ),

          // Addons section (if any)
          if (item.addons.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildAddonsSection(context, l10n),
          ],
        ],
      ),
    );
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
          // Delete/Trash button (pink background) - now on left
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

          // Plus button (red) - now on right
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

  Widget _buildAddonsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // "الاضافات" label
        const Text(
          'الاضافات',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkBrown,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 8),
        // Addons list with separators
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildAddonChips(),
        ),
      ],
    );
  }

  List<Widget> _buildAddonChips() {
    List<Widget> chips = [];
    for (int i = 0; i < item.addons.length; i++) {
      chips.add(
        Text(
          item.addons[i].name,
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
