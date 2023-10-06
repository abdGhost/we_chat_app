import 'package:flutter/material.dart';

class FormatDateTime {
  // For Formatting Date And Time
  static String formatTime(BuildContext context, String time) {
    final formatedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(formatedTime).format(context);
  }

  static String getLastMessageFormatedTime(BuildContext context, String time) {
    final sentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final now = DateTime.now();

    if (sentTime.day == now.day &&
        sentTime.month == now.month &&
        sentTime.year == now.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    return '${sentTime.day} ${getFormattedMonth(sentTime)}';
  }

  static getFormattedMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
