import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/auth/login_screen.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          // statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white60,
        ),
      );

      if (APIs.firebaseAuth.currentUser != null) {
        print('user -- ${APIs.firebaseAuth.currentUser}');

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const HomeScreen();
        })));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const LoginScreen();
        })));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: deviceSize.height * 0.40,
            right: deviceSize.width * .25,
            width: deviceSize.width * 0.5,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_icon.png',
                ),
                SizedBox(
                  height: deviceSize.height * 0.05,
                ),
                const Text(
                  'Welcome to We Chat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: deviceSize.height * .02,
              left: deviceSize.width * 0.05,
              width: deviceSize.width * 0.9,
              height: deviceSize.height * 0.06,
              child: const Center(
                child: Text(
                  'Version 1.0.1',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
