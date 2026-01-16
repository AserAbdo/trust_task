import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
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
      backgroundColor: AppTheme.backgroundColor,
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
      bottomNavigationBar: _buildBottomNav(l10n),
      floatingActionButton: _buildCartFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildContent(CategoriesLoaded state, AppLocalizations l10n) {
    final categories = state.categories;
    final selectedIndex = state.selectedTabIndex;
    final selectedCategory = categories.isNotEmpty
        ? categories[selectedIndex]
        : null;

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildCategoryTabs(categories, selectedIndex),
        const SizedBox(height: 16),
        _buildCategoryHeader(selectedCategory, l10n),
        const SizedBox(height: 8),
        Expanded(child: _buildProductsList(selectedCategory, l10n)),
      ],
    );
  }

  Widget _buildCategoryTabs(List<Category> categories, int selectedIndex) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return CategoryTab(
            label: categories[index].name,
            isSelected: index == selectedIndex,
            onTap: () {
              context.read<CategoriesCubit>().selectTab(index);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryHeader(Category? category, AppLocalizations l10n) {
    if (category == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.primaryLight.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryLight, width: 1),
        ),
        child: Text(
          category.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryDark,
            fontWeight: FontWeight.bold,
          ),
          textAlign: context.isRtl ? TextAlign.right : TextAlign.left,
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
            Icon(
              Icons.fastfood_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('no_products'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
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
                context.read<CategoriesCubit>().loadCategories();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('retry')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.translate('account'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu_outlined),
            activeIcon: const Icon(Icons.restaurant_menu),
            label: l10n.translate('menu'),
          ),
          const BottomNavigationBarItem(icon: SizedBox(width: 40), label: ''),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_offer_outlined),
            activeIcon: const Icon(Icons.local_offer),
            label: l10n.translate('offers'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.translate('home'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartFab() {
    return BlocBuilder<CartCubit, dynamic>(
      builder: (context, cartState) {
        return FloatingActionButton(
          onPressed: _navigateToCart,
          backgroundColor: AppTheme.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 28,
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
        content: Text('${product.name} added to cart'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
