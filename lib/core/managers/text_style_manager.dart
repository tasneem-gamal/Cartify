import 'package:cartify/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyleManager {
  TextStyleManager._();

  static TextStyle _base({
    required FontWeight fontWeight,
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => TextStyle(
    fontWeight: fontWeight,
    // fontFamily: AppFonts.poppinsFontFamily,
    fontFamily:
        fontFamily ,
    fontSize: size ?? 14,
    decoration: textDecoration ?? TextDecoration.none,
    decorationColor: color ?? AppColors.textPrimary,
    color: color ?? AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle extraLight({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w200,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle light({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w300,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle regular({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w400,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle medium({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w500,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle semiBold({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w600,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle bold({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w700,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle extraBold({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w800,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );

  static TextStyle black({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
    String? fontFamily,
  }) => _base(
    fontWeight: FontWeight.w900,
    size: fontSize,
    color: color,
    textDecoration: textDecoration,
    fontFamily: fontFamily,
  );
}
