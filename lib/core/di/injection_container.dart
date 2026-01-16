import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/language_cubit.dart';
import '../network/api_client.dart';
import '../utils/guest_manager.dart';
import '../../features/categories/data/datasources/categories_remote_datasource.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/product_details/data/datasources/product_details_remote_datasource.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/product_details/domain/usecases/get_product_details_usecase.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/cart_usecases.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Language Cubit (must be registered before other cubits)
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit(prefs: sl()));

  sl.registerLazySingleton(() => ApiClient());

  sl.registerLazySingleton(() => GuestManager(prefs: sl(), apiClient: sl()));

  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  sl.registerFactory(() => CategoriesCubit(getCategoriesUseCase: sl()));

  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductAddonsUseCase(sl()));

  sl.registerFactory(() => ProductDetailsCubit(getProductDetailsUseCase: sl()));

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiClient: sl(), guestManager: sl()),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  sl.registerLazySingleton(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );
}
