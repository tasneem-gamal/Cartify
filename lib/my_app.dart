import 'package:cartify/core/constants/app_colors.dart';
import 'package:cartify/core/constants/app_globals.dart';
import 'package:cartify/core/responsive/responsive_wrapper.dart';
import 'package:cartify/core/routes/app_routes.dart';
import 'package:cartify/core/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ResponsiveWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cartify',
            theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
            themeMode: ThemeMode.light,
            scaffoldMessengerKey: AppGlobals.scaffoldMessengerKey,
            onGenerateRoute: AppRoutes().generateRoute,
            navigatorKey: AppGlobals.navigatorKey,
            navigatorObservers: [AppGlobals.routeObserver],
            initialRoute: RoutesNames.splashScreen,
          ),
        );
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child ?? Container());
  }
}
