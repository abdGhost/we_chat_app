import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/models/chat_user.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    super.key,
    required this.chatuser,
  });

  final ChatUser chatuser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: deviceSize.width * 0.6,
        height: deviceSize.height * 0.35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceSize.height * 0.3),
                child: CachedNetworkImage(
                  width: deviceSize.height * .6,
                  fit: BoxFit.cover,
                  imageUrl: chatuser.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
