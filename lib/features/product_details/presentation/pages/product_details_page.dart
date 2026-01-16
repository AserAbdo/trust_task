import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import '../widgets/addon_section.dart';
import '../widgets/quantity_selector.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            context.isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.translate('product_details'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
                _buildProductImage(context, product.images),
                _buildProductInfo(context, state, l10n),
                if (product.addons.isNotEmpty)
                  _buildAddonsSection(context, state, l10n),
              ],
            ),
          ),
        ),
        _buildAddToCartButton(context, state, l10n),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context, List<String> images) {
    final imageUrl = images.isNotEmpty ? images.first : null;

    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.white,
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.fastfood,
                  size: 100,
                  color: AppTheme.primaryColor,
                ),
              ),
            )
          : Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.fastfood,
                size: 100,
                color: AppTheme.primaryColor,
              ),
            ),
    );
  }

  Widget _buildProductInfo(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    final product = state.product;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${product.price} ${l10n.translate('currency_symbol')}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: QuantitySelector(
              quantity: state.quantity,
              onIncrement: () {
                context.read<ProductDetailsCubit>().incrementQuantity();
              },
              onDecrement: () {
                context.read<ProductDetailsCubit>().decrementQuantity();
              },
            ),
          ),
          if (product.description != null &&
              product.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              product.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddonsSection(
    BuildContext context,
    ProductDetailsLoaded state,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...state.product.addons.asMap().entries.map((entry) {
            final index = entry.key;
            final addon = entry.value;
            return AddonSection(
              addon: addon,
              index: index,
              selectedOptions: state.selectedOptions[addon.id] ?? [],
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _addToCart(context, state, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.translate('add_to_cart'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
      productName: product.name,
      productImage: product.images.isNotEmpty ? product.images.first : null,
      price: state.totalPrice / state.quantity,
      quantity: state.quantity,
      addons: addons,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
  }
}
