import 'package:cartify/core/constants/api_endpoints.dart';
import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/infrastructure/network_manager.dart';
import 'package:cartify/infrastructure/response_wrapper.dart';

abstract class CategoriesService {
  Future<ResponseWrapper<List<ProductCategoryModel>?>> getCategories();
}

class CategoriesServiceImpl implements CategoriesService {
  @override
  Future<ResponseWrapper<List<ProductCategoryModel>?>> getCategories() async {
    final networkManager = AppGlobals.locator<NetworkManager>();

    final response = await networkManager.get(
      ApiEndPoints.categories,
      fromJsonBuilder: ProductCategoryModel.listFromDynamic,
    );

    return response;
  }
}
