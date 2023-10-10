import 'package:cached_network_image/cached_network_image.dart';
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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: _showBottomSheet,
      child: isMe ? _greenMessage() : _blueMessage(),
    );
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
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? deviceSize.width * 0.03
                  : deviceSize.width * 0.04,
            ),
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
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(deviceSize.height * 0.02),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: widget.message.message,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: deviceSize.width * 0.05),
          child: Text(
            FormatDateTime.formatTime(context, widget.message.sent!),
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
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? deviceSize.width * 0.03
                  : deviceSize.width * 0.04,
            ),
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
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.message,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(deviceSize.height * 0.01),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: widget.message.message,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: deviceSize.height * 0.015,
                  horizontal: deviceSize.width * 0.4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              _OptionItem(
                icon: const Icon(
                  Icons.copy,
                  color: Colors.blue,
                  size: 26,
                ),
                name: 'Copy',
                onTap: () {},
              )
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: deviceSize.width * 0.05,
          top: deviceSize.height * 0.015,
          bottom: deviceSize.height * 0.025,
        ),
        child: Row(
          children: [
            icon,
            Text(
              '     $name',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
