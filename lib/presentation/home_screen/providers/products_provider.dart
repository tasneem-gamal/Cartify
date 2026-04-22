import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/core/enums/snackbar_message_type.dart';
import 'package:cartify/core/managers/toast_manager.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/data/repositories/categories_repository.dart';
import 'package:cartify/data/repositories/products_repository.dart';
import 'package:cartify/infrastructure/exceptions/exceptions_handler.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsRepository productsRepository;
  final CategoriesRepository categoriesRepository;

  ProductsProvider({
    required this.productsRepository,
    required this.categoriesRepository,
  });

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductModel> _allProducts = const [];
  List<ProductModel> _products = const [];
  List<ProductCategoryModel> _categories = const [];
  int? _selectedCategoryId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductModel> get products => _products;
  List<ProductCategoryModel> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _products.isEmpty && _errorMessage == null;

  Future<void> fetchInitialData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        productsRepository.getProducts(),
        categoriesRepository.getCategories(),
      ]);

      _allProducts = results[0] as List<ProductModel>;
      _categories = results[1] as List<ProductCategoryModel>;
      _selectedCategoryId = null;
      _applyCategoryFilter();
      _errorMessage = null;
    } catch (error) {
      _allProducts = const [];
      _products = const [];
      _categories = const [];
      _errorMessage = ExceptionsHandler.getUserFacingMessage(error);
      _showErrorToast(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;

    _selectedCategoryId = categoryId;
    _applyCategoryFilter();
    notifyListeners();
  }

  void _applyCategoryFilter() {
    if (_selectedCategoryId == null) {
      _products = List<ProductModel>.from(_allProducts);
      return;
    }

    _products = _allProducts
        .where((product) => product.category.id == _selectedCategoryId)
        .toList();
  }

  void _showErrorToast(String message) {
    final navigatorState = AppGlobals.navigatorKey.currentState;
    final overlayContext = navigatorState?.overlay?.context;
    final context = overlayContext ?? AppGlobals.navigatorKey.currentContext;

    if (context != null && context.mounted) {
      ToastManager.show(
        context: context,
        message: message,
        type: SnackBarMessageType.error,
      );
    }
  }
}
