import 'package:cartify/core/constants/app_assets.dart';
import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/extentions/size_extension.dart';
import 'package:cartify/core/managers/text_style_manager.dart';
import 'package:cartify/core/utils/custom_image.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/presentation/home_screen/widgets/circular_icon_action.dart';
import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  final ProductModel item;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCartTap;

  const ProductItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = context.setMinSize(24);
    final imageUrl = _resolvePrimaryImage(item);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(cardRadius),
                        ),
                        child: CustomImage.network(
                          src: imageUrl,
                          fit: BoxFit.cover,
                          errorPlaceholder: AppAssets.logoPng,
                          errorPlaceholderFit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: context.setHeight(10),
                      right: context.setWidth(10),
                      child: CircularIconAction(
                        icon: Icons.favorite_border_rounded,
                        size: context.setMinSize(38),
                        iconSize: context.setMinSize(20),
                        iconColor: AppColors.textPrimary,
                        onTap: onFavoriteTap,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: context.setEdgeInsets(
                    left: 12,
                    top: 12,
                    right: 12,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleManager.semiBold(
                          fontSize: context.setSp(17),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.setHeight(6)),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleManager.regular(
                          fontSize: context.setSp(12),
                          color: AppColors.textDescription,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)}LE',
                            style: TextStyleManager.bold(
                              fontSize: context.setSp(17),
                              color: AppColors.redDefault,
                            ),
                          ),
                          const Spacer(),
                          CircularIconAction(
                            icon: Icons.shopping_bag_outlined,
                            onTap: onAddToCartTap,
                            size: context.setMinSize(38),
                            iconSize: context.setMinSize(20),
                            borderColor: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolvePrimaryImage(ProductModel product) {
    for (final image in product.images) {
      final trimmed = image.trim();
      if (_isValidHttpUrl(trimmed)) {
        return trimmed;
      }
    }

    final categoryImage = product.category.image.trim();
    if (_isValidHttpUrl(categoryImage)) {
      return categoryImage;
    }

    return '';
  }

  bool _isValidHttpUrl(String value) {
    if (value.isEmpty) return false;

    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
