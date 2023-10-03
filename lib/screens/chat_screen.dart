import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/models/chat_user.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser chatUser;
  const ChatScreen({
    super.key,
    required this.chatUser,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(deviceSize.height * 0.2),
            child: CachedNetworkImage(
              width: deviceSize.height * .2,
              height: deviceSize.height * .2,
              fit: BoxFit.cover,
              imageUrl: widget.chatUser.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatUser.toJson());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: appBar(),
        ),
      ),
    );
  }
}
