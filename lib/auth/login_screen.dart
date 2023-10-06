import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/screens/home_screen.dart';
import 'package:we_chat_app/dialogs/dialogs_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  _handleGoogleSigninButtonClick() {
    DialogsWidget.showProgressBar(context);
    singInWithGoogle().then((user) async {
      if (user != null) {
        log('user -- ${user.user}');
        log('user additional info -- ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const HomeScreen())));
        } else {
          APIs.createUser().then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const HomeScreen())));
          });
        }
      }
    });
  }

  Future<UserCredential?> singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('here');
      log('singInWithGoogle $e');
      DialogsWidget.showSnackbar(
        context,
        'Something went wrong, Check Internet connection',
        SnackBarBehavior.floating,
      );
      return null;
    }
  }

  void closeAppUsingExit() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: deviceSize.height * 0.25,
            right:
                _isAnimated ? deviceSize.width * .25 : -deviceSize.width * .5,
            width: deviceSize.width * 0.5,
            child: Image.asset(
              'assets/images/logo_icon.png',
            ),
          ),
          Positioned(
            bottom: deviceSize.height * .15,
            left: deviceSize.width * 0.05,
            width: deviceSize.width * 0.9,
            height: deviceSize.height * 0.06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromARGB(255, 133, 248, 192),
                elevation: 1,
              ),
              onPressed: () {
                _handleGoogleSigninButtonClick();
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: deviceSize.height * .03,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In with ',
                    ),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
