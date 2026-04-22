import 'package:cartify/core/extentions/size_extension.dart';
import 'package:flutter/material.dart';


class ResponsiveUsageExample extends StatelessWidget {
  const ResponsiveUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.setEdgeInsets(all: 16),
        child: Column(
          children: [
            Container(
              width: context.setWidth(200),
              height: context.setHeight(100),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: context.setBorderRadius(12),
              ),
              child: Center(
                child: Text(
                  'Responsive Container',
                  style: TextStyle(
                    fontSize: context.setSp(16),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: context.setHeight(20)),
            
            Container(
              padding: context.setEdgeInsets(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                'Responsive Padding',
                style: TextStyle(fontSize: context.setSp(14)),
              ),
            ),
            
            SizedBox(height: context.setHeight(20)),
            
            Container(
              width: context.setMinSize(48),
              height: context.setMinSize(48),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            
            SizedBox(height: context.setHeight(20)),
            
            Text(
              'Screen Width: ${context.screenWidth.toStringAsFixed(0)}',
              style: TextStyle(fontSize: context.setSp(12)),
            ),
            Text(
              'Screen Height: ${context.screenHeight.toStringAsFixed(0)}',
              style: TextStyle(fontSize: context.setSp(12)),
            ),
            Text(
              'Is Landscape: ${context.isLandscape}',
              style: TextStyle(fontSize: context.setSp(12)),
            ),
          ],
        ),
      ),
    );
  }
}


