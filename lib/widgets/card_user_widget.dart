import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/models/chat_user.dart';

import '../screens/chat_screen.dart';

class CardUserWidget extends StatefulWidget {
  final ChatUser user;
  const CardUserWidget({
    super.key,
    required this.user,
  });

  @override
  State<CardUserWidget> createState() => _CardUserWidgetState();
}

class _CardUserWidgetState extends State<CardUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: deviceSize.width * 0.04,
        vertical: 4,
      ),
      elevation: 0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return ChatScreen(
              chatUser: widget.user,
            );
          })));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(deviceSize.height * 0.3),
            child: CachedNetworkImage(
              width: deviceSize.height * 0.055,
              height: deviceSize.height * 0.055,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about),
          // trailing: const Text(
          //   '12:00 PM',
          //   style: TextStyle(
          //     color: Colors.black54,
          //   ),
          // ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
