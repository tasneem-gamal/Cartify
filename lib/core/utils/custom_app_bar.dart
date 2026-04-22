import 'package:cartify/core/constants/app_assets.dart';
import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/managers/text_style_manager.dart';
import 'package:cartify/core/utils/app_bar_title_content_builder.dart';
import 'package:cartify/core/utils/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Icon? icon;
  final double? elevation;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool? backIcon;
  final TextStyle? titleStyle;
  final double actionsPadding;
  final Color? backColor;
  final Function()? backFunction;
  final Widget? titleWidget;
  final bool enableBottomBorder;
  final bool lightStatusBar;
  final double leadingWidth;
  final bool isEcommerce;
  final bool showSearchAction;
  final bool showCartAction;
  final int cartItemCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  const CustomAppBar({
    super.key,
    this.actionsPadding = 16,
    this.title,
    this.backColor,
    this.icon,
    this.elevation,
    this.centerTitle = false,
    this.actions,
    this.backIcon = true,
    this.backFunction,
    this.titleStyle,
    this.titleWidget,
    this.enableBottomBorder = false,
    this.lightStatusBar = true,
    this.leadingWidth = 30,
    this.isEcommerce = false,
    this.showSearchAction = false,
    this.showCartAction = false,
    this.cartItemCount = 0,
    this.onSearchTap,
    this.onCartTap,
  });

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final resolvedBackgroundColor =
        backColor ?? (isEcommerce ? AppColors.white : AppColors.transparent);

    final shouldShowLogo = icon == null && backIcon == false;

    final trailingActions = <Widget>[
      if (showSearchAction)
        _buildEcommerceAction(
          context: context,
          iconData: Icons.search_rounded,
          onTap: onSearchTap,
        ),
      if (showCartAction)
        _buildEcommerceAction(
          context: context,
          iconData: Icons.shopping_bag_outlined,
          onTap: onCartTap,
          badgeCount: cartItemCount,
        ),
      if (actions != null && actions!.isNotEmpty) ...actions!,
      if ((showSearchAction ||
          showCartAction ||
          (actions?.isNotEmpty ?? false)))
        SizedBox(width: actionsPadding),
    ];

    return AppBar(
      scrolledUnderElevation: 0,
      leadingWidth: shouldShowLogo && isEcommerce ? 90 : leadingWidth,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: lightStatusBar
            ? Brightness.light
            : Brightness.dark, // For Android (dark icons)
        statusBarBrightness: lightStatusBar
            ? Brightness.light
            : Brightness.dark, // For iOS (dark icons)
      ),
      elevation: elevation ?? 0,
      backgroundColor: resolvedBackgroundColor,
      automaticallyImplyLeading: false,
      leading: shouldShowLogo
          ? Padding(
              padding: EdgeInsets.only(left: isEcommerce ? 16 : 0),
              child: CustomImage.asset(
                src: AppAssets.logoPng,
                height: isEcommerce ? 34 : 40,
                fit: BoxFit.contain,
              ),
            )
          : IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              icon:
                  icon ??
                  const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primary,
                    weight: 800,
                  ),
              onPressed: backFunction ?? () => Navigator.of(context).pop(),
            ),
      actions: trailingActions.isNotEmpty ? trailingActions : null,
      title: AppBarTitleContentBuilder(
        title: title,
        titleStyle: titleStyle,
        titleWidget: titleWidget,
      ),
      titleTextStyle:
          titleStyle ??
          TextStyleManager.semiBold(
            fontSize: isEcommerce ? 18 : 16,
            color: AppColors.textPrimary,
          ),
      centerTitle: centerTitle,
      bottom: (enableBottomBorder || isEcommerce)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: AppColors.border, height: 1),
            )
          : null,
    );
  }

  Widget _buildEcommerceAction({
    required BuildContext context,
    required IconData iconData,
    VoidCallback? onTap,
    int badgeCount = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Icon(iconData, size: 20, color: AppColors.textPrimary),
            ),
            if (badgeCount > 0)
              Positioned(
                right: -2,
                top: -3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: TextStyleManager.bold(
                        fontSize: 9,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
