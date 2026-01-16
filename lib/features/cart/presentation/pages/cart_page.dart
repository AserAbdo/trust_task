import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

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
          l10n.translate('shopping_cart'),
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
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is CartError) {
            return _buildErrorWidget(state.message, l10n);
          }

          if (state is CartLoaded) {
            if (state.cart.items.isEmpty) {
              return _buildEmptyCart(l10n);
            }
            return _buildCartContent(state, l10n);
          }

          return _buildEmptyCart(l10n);
        },
      ),
    );
  }

  Widget _buildCartContent(CartLoaded state, AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              final item = state.cart.items[index];
              return CartItemCard(
                item: item,
                onIncrement: () {
                  context.read<CartCubit>().incrementQuantity(item.productId);
                },
                onDecrement: () {
                  context.read<CartCubit>().decrementQuantity(item.productId);
                },
                onRemove: () {
                  _showRemoveDialog(item.productId, item.productName);
                },
              );
            },
          ),
        ),
        CartSummary(
          subtotal: state.cart.subtotal,
          tax: state.cart.tax,
          total: state.cart.total,
          couponCode: state.couponCode,
          onApplyCoupon: (code) {
            context.read<CartCubit>().applyCoupon(code);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Coupon "$code" applied'),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        _buildCheckoutButton(l10n),
      ],
    );
  }

  Widget _buildCheckoutButton(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proceeding to checkout...'),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.translate('checkout'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('empty_cart'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('empty_cart_desc'),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu),
              label: Text(l10n.translate('browse_menu')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message, AppLocalizations l10n) {
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
                context.read<CartCubit>().loadCart();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('retry')),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(int productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Item'),
        content: Text('Remove "$productName" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<CartCubit>().removeFromCart(productId);
            },
            child: Text('Remove', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
