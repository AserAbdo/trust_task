import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Dushka Burger',
      'categories': 'Categories',
      'home': 'Home',
      'menu': 'Menu',
      'offers': 'Offers',
      'account': 'Account',
      'cart': 'Cart',
      'view_cart': 'View Cart',
      'shopping_cart': 'Shopping Cart',
      'product_details': 'Product Details',
      'add_to_cart': 'Add to Cart',
      'back': 'Back',
      'price': 'Price',
      'quantity': 'Quantity',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'tax': 'Tax',
      'total_amount': 'Total Amount',
      'checkout': 'Proceed to Checkout',
      'empty_cart': 'Your cart is empty',
      'empty_cart_desc': 'Add some delicious items to your cart',
      'browse_menu': 'Browse Menu',
      'addons': 'Add-ons',
      'extras': 'Extras',
      'select_options': 'Select Options',
      'first_sandwich': 'First Sandwich',
      'second_sandwich': 'Second Sandwich',
      'third_sandwich': 'Third Sandwich',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'no_categories': 'No categories available',
      'no_products': 'No products available',
      'remove': 'Remove',
      'payment_details': 'Payment Details',
      'enter_coupon': 'Enter coupon here',
      'apply': 'Apply',
      'egp': 'EGP',
      'currency_symbol': 'EGP',
      'dushka_burger_offers': 'Dushka Burger Offers',
      'app_offers': 'App Offers',
      'any_3_sandwiches': 'Any 3 slider sandwiches of your choice',
      'truffle': 'Truffle',
      'oji': 'Oji',
      'spicy': 'Spicy',
      'ranchi': 'Ranchi',
      'bacon': 'Bacon',
      'continue_shopping': 'Continue Shopping',
    },
    'ar': {
      'app_name': 'دوشكا برجر',
      'categories': 'الأقسام',
      'home': 'الرئيسية',
      'menu': 'القائمة',
      'offers': 'العروض',
      'account': 'الحساب',
      'cart': 'السلة',
      'view_cart': 'عرض السلة',
      'shopping_cart': 'عربة التسوق',
      'product_details': 'تفاصيل المنتج',
      'add_to_cart': 'أضف إلى السلة',
      'back': 'رجوع',
      'price': 'السعر',
      'quantity': 'الكمية',
      'total': 'المجموع',
      'subtotal': 'السعر الإجمالي',
      'tax': 'الضريبة',
      'total_amount': 'المبلغ الإجمالي',
      'checkout': 'المتابعة للدفع',
      'empty_cart': 'السلة فارغة',
      'empty_cart_desc': 'أضف بعض العناصر اللذيذة إلى سلتك',
      'browse_menu': 'تصفح القائمة',
      'addons': 'الإضافات',
      'extras': 'إضافات',
      'select_options': 'اختر الخيارات',
      'first_sandwich': 'السندوتش الاول',
      'second_sandwich': 'السندوتش الثاني',
      'third_sandwich': 'السندوتش الثالث',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'no_categories': 'لا توجد أقسام متاحة',
      'no_products': 'لا توجد منتجات متاحة',
      'remove': 'إزالة',
      'payment_details': 'تفاصيل الدفع',
      'enter_coupon': 'ادخل الكوبون هنا',
      'apply': 'تطبيق',
      'egp': 'ج.م',
      'currency_symbol': 'ج.م',
      'dushka_burger_offers': 'عروض دوشكا برجر',
      'app_offers': 'عروض الابلكيشن',
      'any_3_sandwiches': 'اي 3 ساندوتشات سلايدر من اختيارك',
      'truffle': 'ترافيل',
      'oji': 'أوجي',
      'spicy': 'سبايسي',
      'ranchi': 'رانشي',
      'bacon': 'بيكون',
      'continue_shopping': 'متابعة التسوق',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  bool get isRtl => Localizations.localeOf(this).languageCode == 'ar';
}
