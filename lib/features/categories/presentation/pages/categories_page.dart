import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../product_details/presentation/pages/product_details_page.dart';
import '../../domain/entities/category.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/category_tab.dart';
import '../widgets/product_card.dart';

/// Main categories page displaying product categories and products
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
              return _ErrorWidget(
                message: state.message,
                onRetry: () => context.read<CategoriesCubit>().loadCategories(),
              );
            }

            if (state is CategoriesLoaded) {
              return _CategoriesContent(
                state: state,
                onProductTap: _navigateToProductDetails,
                onAddToCart: _addToCart,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onIndexChanged: (index) => setState(() => _currentNavIndex = index),
      ),
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

  void _addToCart(Product product) {
    final l10n = context.l10n;
    final productName = product.getLocalizedName(l10n.locale.languageCode);

    context.read<CartCubit>().addToCart(
      productId: product.id,
      productName: product.nameEn ?? product.name,
      productNameAr: product.name,
      productImage: product.image,
      price: double.tryParse(product.price) ?? 0,
      quantity: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          textDirection: l10n.isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.translate('added_to_cart', params: {'name': productName}),
                textDirection: l10n.isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
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

/// Content widget when categories are loaded
class _CategoriesContent extends StatelessWidget {
  final CategoriesLoaded state;
  final void Function(Product) onProductTap;
  final void Function(Product) onAddToCart;

  const _CategoriesContent({
    required this.state,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final categories = state.categories;
    final selectedIndex = state.selectedTabIndex;
    final selectedCategory =
        categories.isNotEmpty && selectedIndex < categories.length
        ? categories[selectedIndex]
        : null;

    return Column(
      children: [
        const SizedBox(height: 16),
        _CategoryTabs(categories: categories, selectedIndex: selectedIndex),
        const SizedBox(height: 24),
        _SectionHeader(category: selectedCategory),
        const SizedBox(height: 16),
        Expanded(
          child: _ProductsList(
            category: selectedCategory,
            onProductTap: onProductTap,
            onAddToCart: onAddToCart,
          ),
        ),
      ],
    );
  }
}

/// Category tabs widget
class _CategoryTabs extends StatelessWidget {
  final List<Category> categories;
  final int selectedIndex;

  const _CategoryTabs({required this.categories, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CategoryTab(
            label: l10n.translate('dushka_burger_offers'),
            isSelected: selectedIndex == 0,
            emoji: '🍔',
            onTap: () => context.read<CategoriesCubit>().selectTab(0),
          ),
          const SizedBox(width: 10),
          CategoryTab(
            label: l10n.translate('app_offers'),
            isSelected: selectedIndex == 1,
            icon: Icons.phone_android,
            onTap: () => context.read<CategoriesCubit>().selectTab(1),
          ),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final Category? category;

  const _SectionHeader({this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String headerText = l10n.translate('dushka_burger_offers');
    if (category != null && category!.name.isNotEmpty) {
      headerText = category!.getLocalizedName(l10n.locale.languageCode);
    }

    return Directionality(
      textDirection: l10n.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            headerText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Products list widget
class _ProductsList extends StatelessWidget {
  final Category? category;
  final void Function(Product) onProductTap;
  final void Function(Product) onAddToCart;

  const _ProductsList({
    this.category,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (category == null || category!.products.isEmpty) {
      return _EmptyProductsWidget();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: category!.products.length,
      itemBuilder: (context, index) {
        final product = category!.products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap(product),
          onAddToCart: () => onAddToCart(product),
        );
      },
    );
  }
}

/// Empty products placeholder widget
class _EmptyProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
}

/// Error widget with retry button
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              onPressed: onRetry,
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
}
