import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/routes/router.dart';

class App extends StatelessWidget {
  final _router = SubscriptionManagerRouter();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        routerConfig: _router.config(),
      ),
    );
  }
}
