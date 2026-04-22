import 'package:cartify/core/constants/app_assets.dart';
import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/extentions/size_extension.dart';
import 'package:cartify/core/managers/text_style_manager.dart';
import 'package:cartify/core/utils/custom_image.dart';
import 'package:flutter/material.dart';


class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage.asset(
              src: AppAssets.logoPng,
              width: context.setWidth(100),
            ),
            SizedBox(height: context.setHeight(24)),
            Text(
              'Oops! Something went wrong',
              style: TextStyleManager.bold(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.setHeight(8)),
            Text(
              'We couldn\'t load the products.\nPlease check your connection and try again.',
              style: TextStyleManager.regular(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
