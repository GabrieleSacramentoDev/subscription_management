import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subscription_management/src/app.dart';

const _splashLogoAsset = 'assets/images/subscription_management_logo.png';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _preloadSplashLogo();
  runApp(App());
}

Future<void> _preloadSplashLogo() async {
  const asset = AssetImage(_splashLogoAsset);
  final completer = Completer<void>();
  final stream = asset.resolve(ImageConfiguration.empty);

  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (image, synchronousCall) {
      stream.removeListener(listener);
      if (!completer.isCompleted) {
        completer.complete();
      }
    },
    onError: (exception, stackTrace) {
      stream.removeListener(listener);
      if (!completer.isCompleted) {
        completer.completeError(exception, stackTrace);
      }
    },
  );

  stream.addListener(listener);
  await completer.future;
}
