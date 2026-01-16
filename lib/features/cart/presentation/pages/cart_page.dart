import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/back_button.dart';
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
  // Colors matching the design
  static const Color linenColor = Color(0xFFFAF0E6);
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: linenColor,
      appBar: _buildAppBar(context, l10n),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
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
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: CustomBackButton(onPressed: () => Navigator.pop(context)),
        ),
      ),
      title: Text(
        l10n.translate('shopping_cart'),
        style: const TextStyle(
          color: darkBrown,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCartContent(CartLoaded state, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Cart items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          // Cart summary
          CartSummary(
            subtotal: state.cart.subtotal,
            tax: state.cart.tax,
            total: state.cart.total,
            couponCode: state.couponCode,
            onApplyCoupon: (code) {
              context.read<CartCubit>().applyCoupon(code);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تطبيق الكوبون "$code"'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          // Checkout button
          _buildCheckoutButton(l10n),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      color: linenColor,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري الانتقال للدفع...'),
                  backgroundColor: redColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: redColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.translate('checkout'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                color: redColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: redColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('empty_cart'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('empty_cart_desc'),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu),
              label: Text(l10n.translate('browse_menu')),
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CartCubit>().loadCart();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: Colors.white,
              ),
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
        title: const Text('حذف المنتج', textDirection: TextDirection.rtl),
        content: Text(
          'هل تريد حذف "$productName" من السلة؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<CartCubit>().removeFromCart(productId);
            },
            child: const Text('حذف', style: TextStyle(color: redColor)),
          ),
        ],
      ),
    );
  }
}
