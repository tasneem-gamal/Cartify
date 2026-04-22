import 'dart:math';
import 'package:cartify/core/responsive/size_provider.dart';
import 'package:flutter/material.dart';

extension SizeHelperExtension on BuildContext {
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  double get screenWidth => isLandscape
      ? MediaQuery.of(this).size.height
      : MediaQuery.of(this).size.width;

  double get screenHeight => isLandscape
      ? MediaQuery.of(this).size.width
      : MediaQuery.of(this).size.height;

  SizeProvider get sizeProvider => SizeProvider.of(this);

  double get scaleWidth => sizeProvider.width / sizeProvider.baseSize.width;

  double get scaleHeight => sizeProvider.height / sizeProvider.baseSize.height;

  double setWidth(num w) {
    return w * scaleWidth;
  }

  double setHeight(num h) {
    return h * scaleHeight;
  }

  double setSp(num fontSize) {
    return fontSize * scaleWidth;
  }

  double setMinSize(num size) {
    return size * min(scaleWidth, scaleHeight);
  }

  // Additional helper for responsive padding
  EdgeInsets setEdgeInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      return EdgeInsets.all(setWidth(all));
    }
    return EdgeInsets.only(
      top: top != null ? setHeight(top) : (vertical != null ? setHeight(vertical) : 0),
      bottom: bottom != null ? setHeight(bottom) : (vertical != null ? setHeight(vertical) : 0),
      left: left != null ? setWidth(left) : (horizontal != null ? setWidth(horizontal) : 0),
      right: right != null ? setWidth(right) : (horizontal != null ? setWidth(horizontal) : 0),
    );
  }

  // Helper for responsive border radius
  BorderRadius setBorderRadius(double radius) {
    return BorderRadius.circular(setWidth(radius));
  }

  // Helper for responsive size
  Size setSize(double width, double height) {
    return Size(setWidth(width), setHeight(height));
  }
}
