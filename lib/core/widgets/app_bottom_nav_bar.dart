import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../../features/cart/presentation/cubit/cart_state.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/account/presentation/pages/account_page.dart';
import 'nav_icons/nav_icons.dart';

/// Navigation tab indices
abstract class NavIndex {
  static const int home = 0;
  static const int menu = 1;
  static const int cart = 2;
  static const int offers = 3;
  static const int account = 4;
}

/// Reusable bottom navigation bar with custom icons and cart FAB
///
/// Usage:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: AppBottomNavBar(
///     currentIndex: _currentNavIndex,
///     onIndexChanged: (index) => setState(() => _currentNavIndex = index),
///   ),
/// )
/// ```
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  // Color constants
  static const Color darkBrown = Color(0xFF412216);
  static const Color greyColor = Color(0xFF9B806E);
  static const Color linenColor = Color(0xFFFAF0E6);

  // Fixed dimensions to prevent icon movement
  static const double _navBarHeight = 85.0;
  static const double _navItemWidth = 40.0;
  static const double _iconSize = 24.0;
  static const double _cartFabSize = 76.0; // Bigger cart button
  static const double _cartFabOuterSize = 100.0; // Bigger outer ring

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
        // Enhanced shadow at the top border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _navBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home
              _NavItem(
                icon: HomeNavIcon(isSelected: currentIndex == NavIndex.home),
                label: l10n.translate('home'),
                isSelected: currentIndex == NavIndex.home,
                onTap: () => onIndexChanged(NavIndex.home),
              ),
              // Menu
              _NavItem(
                icon: MenuNavIcon(isSelected: currentIndex == NavIndex.menu),
                label: l10n.translate('menu'),
                isSelected: currentIndex == NavIndex.menu,
                onTap: () => onIndexChanged(NavIndex.menu),
              ),
              // Cart FAB (Center)
              _CartFab(onTap: () => _navigateToCart(context)),
              // Offers
              _NavItem(
                icon: OffersNavIcon(
                  isSelected: currentIndex == NavIndex.offers,
                ),
                label: l10n.translate('offers'),
                isSelected: currentIndex == NavIndex.offers,
                onTap: () => onIndexChanged(NavIndex.offers),
              ),
              // Account
              _NavItem(
                icon: AccountNavIcon(
                  isSelected: currentIndex == NavIndex.account,
                ),
                label: l10n.translate('account'),
                isSelected: currentIndex == NavIndex.account,
                onTap: () => _navigateToAccount(context),
              ),
            ],
          ),
        ),
      ),
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

/// Individual navigation item with fixed width to prevent movement
class _NavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        // Fixed width prevents icons from shifting when labels change
        width: AppBottomNavBar._navItemWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fixed size container for icon to prevent movement
            SizedBox(
              width: AppBottomNavBar._iconSize,
              height: AppBottomNavBar._iconSize,
              child: Center(child: icon),
            ),
            const SizedBox(height: 4),
            // Fixed height for text to prevent layout shift
            SizedBox(
              height: 15,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? AppBottomNavBar.darkBrown
                      : AppBottomNavBar.greyColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cart floating action button in the center
class _CartFab extends StatelessWidget {
  final VoidCallback onTap;

  const _CartFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        int itemCount = 0;
        if (cartState is CartLoaded) {
          itemCount = cartState.cart.items.length;
        }

        return Transform.translate(
          offset: const Offset(0, -30), // Bigger offset for larger FAB
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              // Fixed outer size to prevent movement
              width: AppBottomNavBar._cartFabOuterSize,
              height: AppBottomNavBar._cartFabOuterSize,
              child: Center(
                child: Container(
                  width: AppBottomNavBar._cartFabOuterSize,
                  height: AppBottomNavBar._cartFabOuterSize,
                  decoration: BoxDecoration(
                    // Gradient-like shadow ring around the button
                    color: AppBottomNavBar.darkBrown.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppBottomNavBar.darkBrown.withValues(alpha: 0.18),
                      width: 12,
                    ),
                    boxShadow: [],
                  ),
                  child: Center(
                    child: Container(
                      width: AppBottomNavBar._cartFabSize,
                      height: AppBottomNavBar._cartFabSize,
                      decoration: BoxDecoration(
                        color: AppBottomNavBar.darkBrown,
                        shape: BoxShape.circle,
                        boxShadow: [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(40, 40), // Bigger icon
                            painter: ShoppingBagPainter(),
                          ),
                          if (itemCount > 0)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    itemCount > 99 ? '99+' : '$itemCount',
                                    style: const TextStyle(
                                      color: AppBottomNavBar.darkBrown,
                                      fontSize: 11,
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
            ),
          ),
        );
      },
    );
  }
}
