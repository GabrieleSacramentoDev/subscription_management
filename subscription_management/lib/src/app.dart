import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/routes/router.dart';

class App extends StatelessWidget {
  static const splashBackgroundColor = Color.fromRGBO(228, 228, 237, 1);

  final _router = SubscriptionManagerRouter();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: splashBackgroundColor,
          canvasColor: splashBackgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: splashBackgroundColor,
            surface: splashBackgroundColor,
          ),
        ),
        builder: (context, child) => ColoredBox(
          color: splashBackgroundColor,
          child: child,
        ),
        routerConfig: _router.config(),
      ),
    );
  }
}
