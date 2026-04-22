import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/managers/text_style_manager.dart';
import 'package:flutter/material.dart';

class AppBarTitleContentBuilder extends StatelessWidget {
  const AppBarTitleContentBuilder({
    super.key,
    this.title,
    this.titleStyle,
    this.titleWidget,
  });

  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Text(
        title!,
        style:
            titleStyle ??
            TextStyleManager.semiBold(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
      );
    }
    if (titleWidget != null) {
      return titleWidget!;
    }
    return const SizedBox.shrink();
  }
}
