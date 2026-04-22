import 'package:cartify/core/constants/api_endpoints.dart';
import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/infrastructure/network_manager.dart';
import 'package:cartify/infrastructure/response_wrapper.dart';

abstract class ProductsService {
  Future<ResponseWrapper<List<ProductModel>?>> getProducts({int? categoryId});
}

class ProductsServiceImpl implements ProductsService {
  @override
  Future<ResponseWrapper<List<ProductModel>?>> getProducts({
    int? categoryId,
  }) async {
    final networkManager = AppGlobals.locator<NetworkManager>();

    final response = await networkManager.get(
      ApiEndPoints.products,
      queryParameters: categoryId != null
          ? <String, dynamic>{'categoryId': categoryId}
          : null,
      fromJsonBuilder: ProductModel.listFromDynamic,
    );

    return response;
  }
}
