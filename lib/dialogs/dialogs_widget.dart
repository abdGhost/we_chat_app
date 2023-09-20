import 'package:flutter/material.dart';

class DialogsWidget {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
