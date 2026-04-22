import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppGlobals {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static GetIt locator = GetIt.instance;
}
