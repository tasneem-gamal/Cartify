import 'package:cartify/core/routes/routes_names.dart';
import 'package:cartify/presentation/home_screen/views/home_screen.dart';
import 'package:cartify/presentation/splash_screen/views/splash_screen.dart';
import 'package:cartify/presentation/unknown_route_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case RoutesNames.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
    }
  }
}
