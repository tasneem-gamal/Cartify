import 'package:cartify/core/di/service_locator.dart';
import 'package:cartify/core/managers/shared_pref_manager.dart';
import 'package:cartify/my_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();
  setupServiceLocator();

  runApp(RestartWidget(child: MyApp()));
}
