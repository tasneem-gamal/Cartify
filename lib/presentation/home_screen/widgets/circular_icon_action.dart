import 'package:cartify/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CircularIconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;

  const CircularIconAction({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 38,
    this.iconSize = 20,
    this.backgroundColor = AppColors.white,
    this.iconColor = AppColors.textPrimary,
    this.borderColor = AppColors.grey200,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
