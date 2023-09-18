import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/models/chat_user.dart';

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
        onTap: () {},
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about),
          trailing: Text(
            widget.user.createdAt,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
