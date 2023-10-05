import 'package:flutter/material.dart';

class FormatDateTime {
  // For Formatting Date And Time
  static String formatTime(BuildContext context, String time) {
    final formatedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(formatedTime).format(context);
  }
}
