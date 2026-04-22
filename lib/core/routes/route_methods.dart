import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/core/routes/routes_names.dart';
import 'package:flutter/material.dart';

class RouteMethods {
  static void navigateToSplashScreen({
    bool isReplacementAndRemoveUntil = false,
  }) {
    _createNavigation(
      isReplacementAndRemoveUntil: isReplacementAndRemoveUntil,
      routeName: RoutesNames.splashScreen,
    );
  }

  static void navigateToHomeScreen({bool isReplacementAndRemoveUntil = false}) {
    _createNavigation(
      isReplacementAndRemoveUntil: isReplacementAndRemoveUntil,
      routeName: RoutesNames.homeScreen,
    );
  }
}

Future<void> _createNavigation({
  bool isReplacementAndRemoveUntil = false,
  String routeName = RoutesNames.unknownRouteScreen,
  Map<String, dynamic>? args,
}) async {
  if (isReplacementAndRemoveUntil) {
    await Navigator.of(
      AppGlobals.navigatorKey.currentContext!,
    ).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: args);
  } else {
    await Navigator.of(
      AppGlobals.navigatorKey.currentContext!,
    ).pushNamed(routeName, arguments: args);
  }
}
