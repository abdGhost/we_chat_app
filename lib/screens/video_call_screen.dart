import 'package:flutter/material.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/models/message.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../models/chat_user.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          1250509676, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          '72dc196900d6703ede5429bace46abc2667d8344f640dc7d158f6b316d43ddbb', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: '',
      userName: '',
      callID: '',
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
