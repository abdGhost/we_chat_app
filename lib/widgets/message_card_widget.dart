import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../api/api.dart';
import '../dialogs/dialogs_widget.dart';
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
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  // Dialog for editing message
  void _showMessageUpdateDialog() {
    String updateMessage = widget.message.message;

    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Row(
              children: [
                Icon(
                  Icons.message_outlined,
                  color: Colors.blue,
                  size: 28,
                ),
                Text(
                  ' Update Message',
                ),
              ],
            ),
            content: TextFormField(
              initialValue: updateMessage,
              maxLines: null,
              onChanged: (value) => updateMessage = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  APIs.updateMessage(widget.message, updateMessage);
                  DialogsWidget.showSnackbar(
                    context,
                    'Message Update Successful',
                    SnackBarBehavior.fixed,
                  );
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )),
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

  void _showBottomSheet(bool isMe) {
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
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.message))
                            .then((value) {
                          Navigator.of(context).pop();
                          DialogsWidget.showSnackbar(
                            context,
                            'Copied',
                            SnackBarBehavior.fixed,
                          );
                        });
                      },
                    )
                  : _OptionItem(
                      icon: const Icon(
                        Icons.download_done_outlined,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          print(
                              'Download Image URL: ${widget.message.message}');
                          await GallerySaver.saveImage(
                            widget.message.message,
                            albumName: 'We Chat',
                          ).then((success) {
                            Navigator.of(context).pop();

                            if (success != null && success) {
                              DialogsWidget.showSnackbar(
                                context,
                                'Image is Downloaded',
                                SnackBarBehavior.fixed,
                              );
                            }
                          });
                        } catch (e) {
                          print('Error while downloading image: $e');
                        }
                      },
                    ),
              if (isMe)
                Divider(
                  color: Colors.black54,
                  indent: deviceSize.width * 0.04,
                  endIndent: deviceSize.width * 0.04,
                ),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Edit Message',
                  onTap: _showMessageUpdateDialog,
                ),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: 'Delete Message',
                  onTap: () {
                    APIs.deleteMessage(widget.message).then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              Divider(
                color: Colors.black54,
                indent: deviceSize.width * 0.04,
                endIndent: deviceSize.width * 0.04,
              ),
              _OptionItem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                ),
                name:
                    'Sent At: ${FormatDateTime.getMessageTime(context, widget.message.sent!, true)}',
                onTap: () {},
              ),
              _OptionItem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                name: widget.message.read.isEmpty
                    ? 'Read At: Not Seen Yet'
                    : 'Read At: ${FormatDateTime.getMessageTime(context, widget.message.read, true)} ',
                onTap: () {},
              ),
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
          bottom: deviceSize.height * 0.015,
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
