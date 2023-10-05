import 'package:flutter/material.dart';
import '../api/api.dart';
import '../helpers/format_date_time.dart';
import '../main.dart';
import '../models/message.dart';

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
  @override
  Widget build(BuildContext context) {
    return APIs.user!.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //If the user is not me
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: deviceSize.height * 0.01,
              horizontal: deviceSize.width * 0.04,
            ),
            padding: EdgeInsets.all(deviceSize.width * 0.04),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
              ),
              color: const Color.fromARGB(255, 218, 238, 255),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.message,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: deviceSize.width * 0.05),
          child: Text(
            widget.message.sent!,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        )
      ],
    );
  }

  //If user is me
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: deviceSize.width * 0.04,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_outlined,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(
              width: deviceSize.width * 0.02,
            ),
            Text(
              FormatDateTime.formatTime(context, widget.message.sent!),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: deviceSize.height * 0.01,
              horizontal: deviceSize.width * 0.04,
            ),
            padding: EdgeInsets.all(deviceSize.width * 0.04),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
              ),
              color: const Color.fromARGB(255, 171, 248, 174),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                // bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.message,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
