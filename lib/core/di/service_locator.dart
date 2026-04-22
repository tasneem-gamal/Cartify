import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/data/repositories/categories_repository.dart';
import 'package:cartify/data/repositories/products_repository.dart';
import 'package:cartify/data/services/categories_service.dart';
import 'package:cartify/data/services/products_service.dart';
import 'package:cartify/infrastructure/network_manager.dart';

void setupServiceLocator() {
  final locator = AppGlobals.locator;

  if (!locator.isRegistered<NetworkManager>()) {
    locator.registerLazySingleton<NetworkManager>(NetworkManagerImpl.new);
  }

  if (!locator.isRegistered<ProductsService>()) {
    locator.registerLazySingleton<ProductsService>(ProductsServiceImpl.new);
  }

  if (!locator.isRegistered<ProductsRepository>()) {
    locator.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(productsService: locator<ProductsService>()),
    );
  }

  if (!locator.isRegistered<CategoriesService>()) {
    locator.registerLazySingleton<CategoriesService>(CategoriesServiceImpl.new);
  }

  if (!locator.isRegistered<CategoriesRepository>()) {
    locator.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(
        categoriesService: locator<CategoriesService>(),
      ),
    );
  }
}
