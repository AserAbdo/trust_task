import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/language_cubit.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../utils/guest_manager.dart';

// Categories feature
import '../../features/categories/data/datasources/categories_remote_datasource.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';

// Product Details feature
import '../../features/product_details/data/datasources/product_details_remote_datasource.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/product_details/domain/usecases/get_product_details_usecase.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';

// Cart feature
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/cart_usecases.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  //! External dependencies
  await _initExternalDependencies();

  //! Core
  _initCoreDependencies();

  //! Features
  _initCategoriesFeature();
  _initProductDetailsFeature();
  _initCartFeature();
}

/// Initialize external dependencies (SharedPreferences, etc.)
Future<void> _initExternalDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

/// Initialize core dependencies (API client, network info, etc.)
void _initCoreDependencies() {
  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => ApiClient());

  // Language Cubit (singleton for app-wide language state)
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit(prefs: sl()));

  // Guest Manager
  sl.registerLazySingleton(() => GuestManager(prefs: sl(), apiClient: sl()));
}

/// Initialize Categories feature dependencies
void _initCategoriesFeature() {
  // Data sources
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Cubits (factory - new instance each time)
  sl.registerFactory(() => CategoriesCubit(getCategoriesUseCase: sl()));
}

/// Initialize Product Details feature dependencies
void _initProductDetailsFeature() {
  // Data sources
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductAddonsUseCase(sl()));

  // Cubits (factory - new instance each time)
  sl.registerFactory(() => ProductDetailsCubit(getProductDetailsUseCase: sl()));
}

/// Initialize Cart feature dependencies
void _initCartFeature() {
  // Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiClient: sl(), guestManager: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  // Cubits (singleton - shared cart state across app)
  sl.registerLazySingleton(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );
}
