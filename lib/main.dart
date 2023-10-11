import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import '../splash_screen.dart';

import 'firebase_options.dart';

// Global varaible for device size
late Size deviceSize;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) {
      runApp(
        const MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.8,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Chats Notifications Channel',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'chats',
  );
  print('Push Notification result--  $result');
  // initMessaging();
}

void initMessaging() async {
  FlutterLocalNotificationsPlugin fltNotification;
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initSetting = InitializationSettings(
    android: androiInit,
  );
  fltNotification = FlutterLocalNotificationsPlugin();
  fltNotification.initialize(initSetting);
  var androidDetails = const AndroidNotificationDetails(
    'chats',
    'chats',
  );
  print('Android: ----- $androidDetails');
  var generalNotificationDetails = NotificationDetails(
    android: androidDetails,
  );
  print('general notification: ----- $generalNotificationDetails');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message foreground $message');
    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;
    if (notification != null && android != null) {
      fltNotification.show(notification.hashCode, notification.title,
          notification.body, generalNotificationDetails);
    }
  });
}
