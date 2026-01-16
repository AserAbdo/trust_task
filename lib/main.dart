import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoriesCubit>(
          create: (context) => di.sl<CategoriesCubit>(),
        ),
        BlocProvider<CartCubit>(create: (context) => di.sl<CartCubit>()),
      ],
      child: MaterialApp(
        title: 'Dushka Burger',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: _locale,
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: _locale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          );
        },
        home: const CategoriesPage(),
      ),
    );
  }
}
