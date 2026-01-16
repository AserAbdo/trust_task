import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../product_details/presentation/pages/product_details_page.dart';
import '../../domain/entities/category.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/category_tab.dart';
import '../widgets/product_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F3),
      body: SafeArea(
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (state is CategoriesError) {
              return _buildErrorWidget(state.message, l10n);
            }

            if (state is CategoriesLoaded) {
              return _buildContent(state, l10n);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(l10n),
    );
  }

  Widget _buildContent(CategoriesLoaded state, AppLocalizations l10n) {
    final categories = state.categories;
    final selectedIndex = state.selectedTabIndex;
    final selectedCategory =
        categories.isNotEmpty && selectedIndex < categories.length
        ? categories[selectedIndex]
        : null;

    return Column(
      children: [
        const SizedBox(height: 12),
        // Category Tabs
        _buildCategoryTabs(categories, selectedIndex, l10n),
        const SizedBox(height: 20),
        // Section Header
        _buildSectionHeader(selectedCategory, l10n),
        const SizedBox(height: 12),
        // Products List
        Expanded(child: _buildProductsList(selectedCategory, l10n)),
      ],
    );
  }

  Widget _buildCategoryTabs(
    List<Category> categories,
    int selectedIndex,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tab 2: عروض الابلكيشن (App Offers) - on the LEFT
          CategoryTab(
            label: l10n.translate('app_offers'),
            isSelected: selectedIndex == 1,
            icon: Icons.phone_android,
            onTap: () {
              context.read<CategoriesCubit>().selectTab(1);
            },
          ),
          const SizedBox(width: 10),
          // Tab 1: عروض دوشكا برجر (Dushka Burger Offers) - on the RIGHT
          CategoryTab(
            label: l10n.translate('dushka_burger_offers'),
            isSelected: selectedIndex == 0,
            emoji: '🍔',
            onTap: () {
              context.read<CategoriesCubit>().selectTab(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(Category? category, AppLocalizations l10n) {
    if (category == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          category.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildProductsList(Category? category, AppLocalizations l10n) {
    if (category == null || category.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fastfood_outlined,
                size: 50,
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('no_products'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: category.products.length,
      itemBuilder: (context, index) {
        final product = category.products[index];
        return ProductCard(
          product: product,
          onTap: () => _navigateToProductDetails(product),
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('error'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CategoriesCubit>().loadCategories();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(AppLocalizations l10n) {
    const Color brownColor = Color(0xFF5D4037);
    const Color greyColor = Color(0xFFBDBDBD);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // الرئيسية (Home) - Right side in RTL
              _buildNavItem(
                icon: _HomeIcon(isSelected: _currentNavIndex == 0),
                label: l10n.translate('home'),
                index: 0,
                selectedColor: brownColor,
                unselectedColor: greyColor,
              ),
              // القائمة (Menu)
              _buildNavItem(
                icon: _MenuIcon(isSelected: _currentNavIndex == 1),
                label: l10n.translate('menu'),
                index: 1,
                selectedColor: brownColor,
                unselectedColor: greyColor,
              ),
              // Cart FAB (Center)
              _buildCartFab(),
              // العروض (Offers)
              _buildNavItem(
                icon: _OffersIcon(isSelected: _currentNavIndex == 3),
                label: l10n.translate('offers'),
                index: 3,
                selectedColor: brownColor,
                unselectedColor: greyColor,
              ),
              // الحساب (Account) - Left side in RTL
              _buildNavItem(
                icon: _AccountIcon(isSelected: _currentNavIndex == 4),
                label: l10n.translate('account'),
                index: 4,
                selectedColor: brownColor,
                unselectedColor: greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final isSelected = _currentNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
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
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFab() {
    const Color brownColor = Color(0xFF5D4037);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        int itemCount = 0;
        if (cartState is CartLoaded) {
          itemCount = cartState.cart.items.length;
        }

        return Transform.translate(
          offset: const Offset(0, -25),
          child: GestureDetector(
            onTap: _navigateToCart,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: brownColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: brownColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cart icon with smile
                  CustomPaint(
                    size: const Size(32, 32),
                    painter: _CartIconPainter(),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BC34A),
                          shape: BoxShape.circle,
                          border: Border.all(color: brownColor, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
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
        );
      },
    );
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: product.id),
      ),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _addToCart(Product product) {
    context.read<CartCubit>().addToCart(
      productId: product.id,
      productName: product.name,
      productImage: product.image,
      price: double.tryParse(product.price) ?? 0,
      quantity: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product.name} تمت الإضافة للسلة',
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Custom Icon Widgets for Bottom Navigation
class _HomeIcon extends StatelessWidget {
  final bool isSelected;
  const _HomeIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color brownColor = Color(0xFF5D4037);
    const Color greyColor = Color(0xFFBDBDBD);

    return Icon(
      isSelected ? Icons.home : Icons.home_outlined,
      color: isSelected ? brownColor : greyColor,
      size: 26,
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final bool isSelected;
  const _MenuIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color brownColor = Color(0xFF5D4037);
    const Color greyColor = Color(0xFFBDBDBD);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected ? brownColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book,
        color: isSelected ? Colors.white : greyColor,
        size: 22,
      ),
    );
  }
}

class _OffersIcon extends StatelessWidget {
  final bool isSelected;
  const _OffersIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color brownColor = Color(0xFF5D4037);
    const Color greyColor = Color(0xFFBDBDBD);

    return Icon(
      isSelected ? Icons.percent : Icons.percent_outlined,
      color: isSelected ? brownColor : greyColor,
      size: 26,
    );
  }
}

class _AccountIcon extends StatelessWidget {
  final bool isSelected;
  const _AccountIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color brownColor = Color(0xFF5D4037);
    const Color greyColor = Color(0xFFBDBDBD);

    return Icon(
      isSelected ? Icons.person : Icons.person_outline,
      color: isSelected ? brownColor : greyColor,
      size: 26,
    );
  }
}

class _CartIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw bag body
    final bagPath = Path();
    bagPath.moveTo(size.width * 0.2, size.height * 0.35);
    bagPath.lineTo(size.width * 0.15, size.height * 0.9);
    bagPath.quadraticBezierTo(
      size.width * 0.15,
      size.height,
      size.width * 0.25,
      size.height,
    );
    bagPath.lineTo(size.width * 0.75, size.height);
    bagPath.quadraticBezierTo(
      size.width * 0.85,
      size.height,
      size.width * 0.85,
      size.height * 0.9,
    );
    bagPath.lineTo(size.width * 0.8, size.height * 0.35);
    bagPath.close();

    canvas.drawPath(bagPath, paint);

    // Draw handle
    final handlePath = Path();
    handlePath.moveTo(size.width * 0.3, size.height * 0.35);
    handlePath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.1,
    );
    handlePath.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.35,
    );

    canvas.drawPath(handlePath, paint);

    // Draw smile
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(size.width * 0.35, size.height * 0.6);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width * 0.65,
      size.height * 0.6,
    );

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
