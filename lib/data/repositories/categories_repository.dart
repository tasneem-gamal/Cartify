import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/data/services/categories_service.dart';
import 'package:cartify/infrastructure/exceptions/api_exception.dart';

abstract class CategoriesRepository {
  Future<List<ProductCategoryModel>> getCategories();
}

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesService categoriesService;

  CategoriesRepositoryImpl({required this.categoriesService});

  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    final response = await categoriesService.getCategories();

    if (!response.isSuccess || response.data == null) {
      throw FailureResponseException(responseWrapper: response);
    }

    return response.data!;
  }
}
