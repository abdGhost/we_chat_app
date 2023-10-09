import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/models/chat_user.dart';
import 'package:we_chat_app/screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    super.key,
    required this.chatuser,
  });

  final ChatUser chatuser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: deviceSize.width * 0.6,
        height: deviceSize.height * 0.35,
        child: Stack(
          children: [
            Positioned(
              top: deviceSize.height * 0.07,
              left: deviceSize.width * 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceSize.height * 0.25),
                child: CachedNetworkImage(
                  width: deviceSize.width * .5,
                  fit: BoxFit.cover,
                  imageUrl: chatuser.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
              top: deviceSize.height * 0.02,
              left: deviceSize.width * 0.04,
              width: deviceSize.width * 0.55,
              child: Text(
                chatuser.name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: deviceSize.width * 0.01,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              ViewProfileScreen(chatUser: chatuser))));
                },
                minWidth: 0,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
