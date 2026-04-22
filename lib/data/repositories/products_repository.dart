import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/data/services/products_service.dart';
import 'package:cartify/infrastructure/exceptions/api_exception.dart';

abstract class ProductsRepository {
  Future<List<ProductModel>> getProducts({int? categoryId});
}

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsService productsService;

  ProductsRepositoryImpl({required this.productsService});

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final response = await productsService.getProducts(categoryId: categoryId);

    if (!response.isSuccess || response.data == null) {
      throw FailureResponseException(responseWrapper: response);
    }

    return response.data!;
  }
}
