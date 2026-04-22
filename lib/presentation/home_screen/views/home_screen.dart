import 'package:cartify/core/constants/app_assets.dart';
import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/core/extentions/size_extension.dart';
import 'package:cartify/core/managers/text_style_manager.dart';
import 'package:cartify/core/utils/custom_app_bar.dart';
import 'package:cartify/core/utils/custom_image.dart';
import 'package:cartify/core/utils/error_widget.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/data/repositories/categories_repository.dart';
import 'package:cartify/data/repositories/products_repository.dart';
import 'package:cartify/presentation/home_screen/providers/products_provider.dart';
import 'package:cartify/presentation/home_screen/widgets/category_filter_bar.dart';
import 'package:cartify/presentation/home_screen/widgets/product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsProvider>(
      create: (_) => ProductsProvider(
        productsRepository: AppGlobals.locator<ProductsRepository>(),
        categoriesRepository: AppGlobals.locator<CategoriesRepository>(),
      )..fetchInitialData(),
      child: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              backIcon: false,
              title: 'Cartify',
              isEcommerce: true,
              showSearchAction: true,
              showCartAction: true,
              cartItemCount: provider.products.length,
              lightStatusBar: false,
            ),
            body: _HomeBody(provider: provider),
          );
        },
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final ProductsProvider provider;

  const _HomeBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.hasError) {
      return CustomErrorWidget(
        onRetry: provider.fetchInitialData,
      );
    }

    return Skeletonizer(
      enabled: provider.isLoading,
      child: Column(
        children: [
          if (provider.categories.isNotEmpty)
            CategoryFilterBar(
              categories: provider.categories,
              selectedCategoryId: provider.selectedCategoryId,
              onCategorySelected: provider.filterByCategory,
            ),
          Expanded(
            child: provider.isEmpty && !provider.isLoading
                ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImage.asset(src: AppAssets.logoPng, width: context.setWidth(140)),
                    Text('No products found', style: TextStyleManager.bold(),)
                  ],
                ))
                : ProductGridView(
                    items: provider.isLoading
                        ? _skeletonProducts
                        : provider.products,
                  ),
          ),
        ],
      ),
    );
  }

  List<ProductModel> get _skeletonProducts {
    final now = DateTime.now();

    ProductModel createItem() {
      return ProductModel(
        id: 0,
        title: 'Loading product',
        slug: 'loading-product',
        price: 0,
        description: 'Loading description',
        category: ProductCategoryModel(
          id: 0,
          name: 'Loading category',
          slug: 'loading-category',
          image: '',
          creationAt: now,
          updatedAt: now,
        ),
        images: const [''],
        creationAt: now,
        updatedAt: now,
      );
    }

    return [createItem(), createItem(), createItem(), createItem()];
  }
}

