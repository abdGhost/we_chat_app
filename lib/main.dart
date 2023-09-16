import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/auth/login_screen.dart';

import 'firebase_options.dart';

// Global varaible for device size
late Size deviceSize;

main() {
  _initializeFirebase();
  runApp(
    const MyApp(),
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
      home: const LoginScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
