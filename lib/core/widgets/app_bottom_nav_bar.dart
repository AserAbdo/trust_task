import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../../features/cart/presentation/cubit/cart_state.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/account/presentation/pages/account_page.dart';
import 'nav_icons/nav_icons.dart';

/// Reusable bottom navigation bar with custom icons and cart FAB
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  static const Color darkBrown = Color(0xFF412216);
  static const Color greyColor = Color(0xFF9B806E);
  static const Color linenColor = Color(0xFFFAF0E6);

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: linenColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home
              _buildNavItem(
                context: context,
                icon: HomeNavIcon(isSelected: currentIndex == 0),
                label: l10n.translate('home'),
                index: 0,
              ),
              // Menu
              _buildNavItem(
                context: context,
                icon: MenuNavIcon(isSelected: currentIndex == 1),
                label: l10n.translate('menu'),
                index: 1,
              ),
              // Cart FAB (Center)
              _buildCartFab(context),
              // Offers
              _buildNavItem(
                context: context,
                icon: OffersNavIcon(isSelected: currentIndex == 3),
                label: l10n.translate('offers'),
                index: 3,
              ),
              // Account
              _buildNavItem(
                context: context,
                icon: AccountNavIcon(isSelected: currentIndex == 4),
                label: l10n.translate('account'),
                index: 4,
                onTap: () => _navigateToAccount(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required Widget icon,
    required String label,
    required int index,
    VoidCallback? onTap,
  }) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: onTap ?? () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? darkBrown : greyColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFab(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        int itemCount = 0;
        if (cartState is CartLoaded) {
          itemCount = cartState.cart.items.length;
        }

        return Transform.translate(
          offset: const Offset(0, -20),
          child: GestureDetector(
            onTap: () => _navigateToCart(context),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: darkBrown.withValues(alpha: 0.15),
                  width: 14,
                ),
              ),
              child: Center(
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: darkBrown,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkBrown.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(32, 32),
                        painter: ShoppingBagPainter(),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: darkBrown,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _navigateToAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountPage()),
    );
  }
}
