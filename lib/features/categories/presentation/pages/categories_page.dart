import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../account/presentation/pages/account_page.dart';
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
        const SizedBox(height: 16),
        // Category Tabs
        _buildCategoryTabs(categories, selectedIndex, l10n),
        const SizedBox(height: 24),
        // Section Header - Fixed title "عروض دوشكا برجر"
        _buildSectionHeader(selectedCategory, l10n),
        const SizedBox(height: 16),
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
          // Tab 1: عروض دوشكا برجر (Dushka Burger Offers) - on the LEFT now
          CategoryTab(
            label: l10n.translate('dushka_burger_offers'),
            isSelected: selectedIndex == 0,
            emoji: '🍔',
            onTap: () {
              context.read<CategoriesCubit>().selectTab(0);
            },
          ),
          const SizedBox(width: 10),
          // Tab 2: عروض الابلكيشن (App Offers) - on the RIGHT now
          CategoryTab(
            label: l10n.translate('app_offers'),
            isSelected: selectedIndex == 1,
            icon: Icons.phone_android,
            onTap: () {
              context.read<CategoriesCubit>().selectTab(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(Category? category, AppLocalizations l10n) {
    // Always show section header with category name or default Arabic text
    String headerText = 'عروض دوشكا برجر';

    if (category != null && category.name.isNotEmpty) {
      headerText = category.name;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            headerText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000), // Pure black
              letterSpacing: 0.3,
            ),
          ),
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
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);
    const Color linenColor = Color(0xFFFAF0E6);

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
              // الرئيسية (Home) - Right side in RTL
              _buildNavItem(
                icon: _HomeIcon(isSelected: _currentNavIndex == 0),
                label: l10n.translate('home'),
                index: 0,
                selectedColor: darkBrown,
                unselectedColor: greyColor,
              ),
              // القائمة (Menu)
              _buildNavItem(
                icon: _MenuIcon(isSelected: _currentNavIndex == 1),
                label: l10n.translate('menu'),
                index: 1,
                selectedColor: darkBrown,
                unselectedColor: greyColor,
              ),
              // Cart FAB (Center)
              _buildCartFab(),
              // العروض (Offers)
              _buildNavItem(
                icon: _OffersIcon(isSelected: _currentNavIndex == 3),
                label: l10n.translate('offers'),
                index: 3,
                selectedColor: darkBrown,
                unselectedColor: greyColor,
              ),
              // الحساب (Account) - Left side in RTL
              _buildNavItem(
                icon: _AccountIcon(isSelected: _currentNavIndex == 4),
                label: l10n.translate('account'),
                index: 4,
                selectedColor: darkBrown,
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
        if (index == 4) {
          // Navigate to Account page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        } else {
          setState(() {
            _currentNavIndex = index;
          });
        }
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
    const Color darkBrown = Color(0xFF412216);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        int itemCount = 0;
        if (cartState is CartLoaded) {
          itemCount = cartState.cart.items.length;
        }

        return Transform.translate(
          offset: const Offset(0, -20),
          child: GestureDetector(
            onTap: _navigateToCart,
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
                      // Shopping bag icon with face (same as product details)
                      CustomPaint(
                        size: const Size(32, 32),
                        painter: _ShoppingBagPainter(),
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
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    // Advanced home icon with roof shape
    return CustomPaint(
      size: const Size(26, 26),
      painter: _HomeIconPainter(
        color: isSelected ? darkBrown : greyColor,
        isSelected: isSelected,
      ),
    );
  }
}

class _HomeIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  _HomeIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw house shape
    final path = Path();
    // Roof
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.1, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.9);
    path.lineTo(size.width * 0.75, size.height * 0.9);
    path.lineTo(size.width * 0.75, size.height * 0.45);
    path.lineTo(size.width * 0.9, size.height * 0.45);
    path.close();

    canvas.drawPath(path, paint);

    // Draw door
    if (isSelected) {
      final doorPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.55,
          size.width * 0.2,
          size.height * 0.35,
        ),
        doorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuIcon extends StatelessWidget {
  final bool isSelected;
  const _MenuIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: darkBrown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.menu_book_rounded,
          color: Colors.white,
          size: 20,
        ),
      );
    }

    return Icon(Icons.menu_book_outlined, color: greyColor, size: 26);
  }
}

class _OffersIcon extends StatelessWidget {
  final bool isSelected;
  const _OffersIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    // Discount/offers icon
    return Icon(
      isSelected ? Icons.local_offer : Icons.local_offer_outlined,
      color: isSelected ? darkBrown : greyColor,
      size: 26,
    );
  }
}

class _AccountIcon extends StatelessWidget {
  final bool isSelected;
  const _AccountIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color darkBrown = Color(0xFF412216);
    const Color greyColor = Color(0xFF9B806E);

    // Person icon inside a circle
    return CustomPaint(
      size: const Size(28, 28),
      painter: _AccountIconPainter(color: isSelected ? darkBrown : greyColor),
    );
  }
}

class _AccountIconPainter extends CustomPainter {
  final Color color;

  _AccountIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Draw outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw head (small circle)
    final headRadius = size.width * 0.12;
    final headCenter = Offset(center.dx, center.dy - size.height * 0.08);
    canvas.drawCircle(headCenter, headRadius, paint);

    // Draw body (arc at bottom)
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final bodyPath = Path();
    bodyPath.moveTo(
      center.dx - size.width * 0.18,
      center.dy + size.height * 0.28,
    );
    bodyPath.quadraticBezierTo(
      center.dx - size.width * 0.18,
      center.dy + size.height * 0.08,
      center.dx,
      center.dy + size.height * 0.08,
    );
    bodyPath.quadraticBezierTo(
      center.dx + size.width * 0.18,
      center.dy + size.height * 0.08,
      center.dx + size.width * 0.18,
      center.dy + size.height * 0.28,
    );

    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Shopping Bag Painter with face (same as product details page)
class _ShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
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
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(w * 0.35, h * 0.60);
    smilePath.quadraticBezierTo(w * 0.50, h * 0.75, w * 0.65, h * 0.60);
    canvas.drawPath(smilePath, smilePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.38, h * 0.50), 2.5, eyePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.50), 2.5, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
