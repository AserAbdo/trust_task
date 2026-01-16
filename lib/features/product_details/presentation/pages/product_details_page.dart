import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import '../widgets/addon_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductDetailsCubit>()..loadProductDetails(productId),
      child: const _ProductDetailsView(),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView();

  // Colors
  static const Color linenColor = Color(0xFFFAF0E6);
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: linenColor,
      appBar: _buildAppBar(context, l10n),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
            );
          }

          if (state is ProductDetailsError) {
            return _buildErrorWidget(context, state.message, l10n);
          }

          if (state is ProductDetailsLoaded) {
            return _buildContent(context, state, l10n);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      backgroundColor: linenColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 140,
      // Back button on the LEFT
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: CustomBackButton(onPressed: () => Navigator.pop(context)),
        ),
      ),
      title: Text(
        l10n.translate('product_details'),
        style: const TextStyle(
          color: darkBrown,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Cart icon with badge on the RIGHT
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildCartIconWithBadge(),
        ),
      ],
    );
  }

  Widget _buildCartIconWithBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CustomPaint(painter: _ShoppingBagPainter()),
        ),
        // Badge
        Positioned(
          top: -2,
          left: -2,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: redColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    final product = state.product;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image
                _buildProductImage(context, product.images),

                const SizedBox(height: 16),

                // Product Name
                _buildProductName(context, product.displayName),

                const SizedBox(height: 12),

                // Price and Quantity Row
                _buildPriceQuantityRow(context, state, l10n),

                const SizedBox(height: 16),

                // Description
                if (product.displayDescription.isNotEmpty)
                  _buildDescription(context, product.displayDescription),

                // Addons Section
                if (product.addons.isNotEmpty)
                  _buildAddonsSection(context, state, l10n),
              ],
            ),
          ),
        ),

        // Add to Cart Button
        _buildAddToCartButton(context, state, l10n),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context, List<String> images) {
    final imageUrl = images.isNotEmpty ? images.first : null;

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: darkBrown),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.fastfood_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              )
            : Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.fastfood_rounded,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _buildProductName(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: darkBrown,
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildPriceQuantityRow(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price (on the right for RTL - shown on right side of screen)
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                state.product.displayPrice,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: darkBrown,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.translate('currency_symbol'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: darkBrown,
                ),
              ),
            ],
          ),

          // Quantity Selector (on the left for RTL - shown on left side of screen)
          _buildQuantitySelector(context, state),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
    BuildContext context,
    ProductDetailsLoaded state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button (on the left)
          GestureDetector(
            onTap: () =>
                context.read<ProductDetailsCubit>().decrementQuantity(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: Icon(Icons.remove, color: Colors.grey.shade600, size: 24),
            ),
          ),

          // Quantity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${state.quantity}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: darkBrown,
              ),
            ),
          ),

          // Plus Button (on the right)
          GestureDetector(
            onTap: () =>
                context.read<ProductDetailsCubit>().incrementQuantity(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: redColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, String description) {
    return Column(
      children: [
        // Top divider with blur
        _buildBlurredDivider(),
        const SizedBox(height: 12),

        // Description text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),

        const SizedBox(height: 12),
        // Bottom divider with blur
        _buildBlurredDivider(),
      ],
    );
  }

  Widget _buildBlurredDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              spreadRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddonsSection(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    final addons = state.product.addons;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...addons.asMap().entries.map((entry) {
            final index = entry.key;
            final addon = entry.value;
            final isLastAddon = index == addons.length - 1;

            return AddonSection(
              addon: addon,
              index: index,
              selectedOptions: state.selectedOptions[addon.id] ?? [],
              showDivider: !isLastAddon, // No divider after last addon
              onOptionToggle: (label, isRadio) {
                context.read<ProductDetailsCubit>().toggleOption(
                  addon.id,
                  label,
                  isRadio,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _addToCart(context, state, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: redColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.translate('add_to_cart'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    String message,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              l10n.translate('error'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final cubit = context.read<ProductDetailsCubit>();
                final state = cubit.state;
                if (state is ProductDetailsLoaded) {
                  cubit.loadProductDetails(state.product.id);
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('retry')),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    final product = state.product;
    final cubit = context.read<ProductDetailsCubit>();
    final addons = cubit.getSelectedAddonsForCart();

    context.read<CartCubit>().addToCart(
      productId: product.id,
      productName: product.displayName,
      productImage: product.images.isNotEmpty ? product.images.first : null,
      price: state.totalPrice / state.quantity,
      quantity: state.quantity,
      addons: addons,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          textDirection: TextDirection.rtl,
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product.displayName} تمت الإضافة للسلة',
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    Navigator.pop(context);
  }
}

// Custom Shopping Bag Painter (same as categories page)
class _ShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCE1330)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Bag body
    final bagPath = Path();
    bagPath.moveTo(w * 0.15, h * 0.35);
    bagPath.lineTo(w * 0.15, h * 0.85);
    bagPath.quadraticBezierTo(w * 0.15, h * 0.95, w * 0.25, h * 0.95);
    bagPath.lineTo(w * 0.75, h * 0.95);
    bagPath.quadraticBezierTo(w * 0.85, h * 0.95, w * 0.85, h * 0.85);
    bagPath.lineTo(w * 0.85, h * 0.35);
    canvas.drawPath(bagPath, paint);

    // Bag handles
    final handlePath = Path();
    handlePath.moveTo(w * 0.30, h * 0.35);
    handlePath.quadraticBezierTo(w * 0.30, h * 0.15, w * 0.50, h * 0.15);
    handlePath.quadraticBezierTo(w * 0.70, h * 0.15, w * 0.70, h * 0.35);
    canvas.drawPath(handlePath, paint);

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFFCE1330)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(w * 0.35, h * 0.60);
    smilePath.quadraticBezierTo(w * 0.50, h * 0.75, w * 0.65, h * 0.60);
    canvas.drawPath(smilePath, smilePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFFCE1330)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.38, h * 0.50), 2.5, eyePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.50), 2.5, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
