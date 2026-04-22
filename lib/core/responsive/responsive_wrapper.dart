import 'package:cartify/core/responsive/size_provider.dart';
import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final Size baseSize;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.baseSize = const Size(390, 844), // iPhone 12 Pro size as base
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;

    final width = orientation == Orientation.portrait ? size.width : size.height;
    final height = orientation == Orientation.portrait ? size.height : size.width;

    return SizeProvider(
      baseSize: baseSize,
      width: width,
      height: height,
      child: child,
    );
  }
}
