import 'package:flutter/material.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/models/message.dart';

class MessageCardWidget extends StatefulWidget {
  final Message message;
  const MessageCardWidget({
    super.key,
    required this.message,
  });

  @override
  State<StatefulWidget> createState() {
    return _MessageCardWidget();
  }
}

class _MessageCardWidget extends State<MessageCardWidget> {
  Widget _blueMessage() {
    return Container();
  }

  Widget _greenMessage() {
    return Container(
      child: Text(
        widget.message.message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return APIs.user!.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }
}
