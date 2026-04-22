import 'package:cartify/core/constants/app_assets.dart';
import 'package:cartify/core/enums/image_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomImage extends StatelessWidget {
  final ImageType imageType;
  final String? src;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final bool? isMatchingTextDirection;
  final double? radius;
  final String? errorPlaceholder;
  final double? errorPlaceholderWidth;
  final double? errorPlaceholderHeight;
  final BoxFit? errorPlaceholderFit;
  final double? errorIconSize;

  const CustomImage.asset({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.color,
    this.radius = 0,
    this.fit = BoxFit.cover,
  })  : imageType = ImageType.png,
        isMatchingTextDirection = null,
        errorPlaceholder = null,
        errorPlaceholderWidth = null,
        errorPlaceholderHeight = null,
        errorPlaceholderFit = null,
        errorIconSize = null;

  const CustomImage.svg({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.color,
    this.radius = 0,
    this.fit = BoxFit.contain,
    this.isMatchingTextDirection = false,
  })  : imageType = ImageType.svg,
        errorPlaceholder = null,
        errorPlaceholderWidth = null,
        errorPlaceholderHeight = null,
        errorPlaceholderFit = null,
        errorIconSize = null;

  const CustomImage.network({
    super.key,
    this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.errorPlaceholder,
    this.errorPlaceholderWidth,
    this.errorPlaceholderHeight,
    this.errorPlaceholderFit = BoxFit.cover,
    this.errorIconSize = 100,
  })  : imageType = ImageType.network,
        color = null,
        isMatchingTextDirection = null;

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.png:
        return Image.asset(
          src!,
          width: width,
          height: height,
          color: color,
          fit: fit,
        );
      case ImageType.svg:
        return SvgPicture.asset(
          src!,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          matchTextDirection: isMatchingTextDirection!,
        );
      default:
        var child = src != null && src!.isNotEmpty
            ? Image.network(
                src ?? '',
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: height,
                    width: width,
                    child: Center(
                      child: CustomImage.asset(
                        src: AppAssets.logoPng,
                        height: 40,
                        fit: BoxFit.contain,
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;

                  // Show logo immediately if image hasn't loaded yet
                  if (frame == null) {
                    return SizedBox(
                      height: height,
                      width: width,
                      child: Center(
                        child: CustomImage.asset(
                          src: AppAssets.logoPng,
                          height: 40,
                          fit: BoxFit.contain,
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  }

                  return child;
                },
                errorBuilder: (context, error, stackTrace) => errorPlaceholder != null
                    ? Image.asset(
                        errorPlaceholder!,
                        width: errorPlaceholderWidth ?? width,
                        height: errorPlaceholderHeight ?? height,
                        fit: errorPlaceholderFit ?? fit,
                      )
                    : Icon(
                        Icons.image_not_supported,
                        size: errorIconSize,
                      ),
              )
            : errorPlaceholder != null
                ? Image.asset(
                    errorPlaceholder!,
                    width: errorPlaceholderWidth ?? width,
                    height: errorPlaceholderHeight ?? height,
                    fit: errorPlaceholderFit ?? fit,
                  )
                : Icon(Icons.image_not_supported, size: errorIconSize);

        return ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: child,
        );
    }
  }
}
