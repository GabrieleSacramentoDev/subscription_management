import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:subscription_management/firebase_options.dart';
import 'package:subscription_management/src/app.dart';
import 'package:subscription_management/src/modules/streaming_management/external/datasources/notification_datasource_impl.dart';
import 'package:subscription_management/src/setup/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationDataSource = NotificationLocalDataSourceImpl(
    FlutterLocalNotificationsPlugin(),
  );
  await notificationDataSource.init();

  await registerDependencies();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(App());
}
