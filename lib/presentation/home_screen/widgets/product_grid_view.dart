import 'dart:math' as math;

import 'package:cartify/core/extentions/size_extension.dart';
import 'package:cartify/data/models/product_model.dart';
import 'package:cartify/presentation/home_screen/widgets/product_item_card.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatefulWidget {
  final List<ProductModel> items;

  const ProductGridView({super.key, required this.items});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crossSpacing = context.setWidth(12);
    final mainSpacing = context.setHeight(12);

    return GridView.builder(
      padding: context.setEdgeInsets(left: 16, top: 18, right: 16, bottom: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: crossSpacing,
        mainAxisSpacing: mainSpacing,
        childAspectRatio: 0.64,
      ),
      itemBuilder: (context, index) {
        final intervalStart = math.min(0.85, index * 0.08);
        final fadeAnimation = CurvedAnimation(
          parent: _controller,
          curve: Interval(intervalStart, 1, curve: Curves.easeOut),
        );
        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(intervalStart, 1, curve: Curves.easeOutCubic),
              ),
            );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ProductItemCard(item: widget.items[index]),
          ),
        );
      },
    );
  }
}
