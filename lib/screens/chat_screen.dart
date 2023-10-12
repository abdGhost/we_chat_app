import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/helpers/format_date_time.dart';
import 'package:we_chat_app/screens/video_call_screen.dart';
import 'package:we_chat_app/screens/view_profile_screen.dart';
import '../api/api.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card_widget.dart';

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
  @override
  void initState() {
    super.initState();
  }

  final _messageController = TextEditingController();

  bool _showEmoji = false;
  bool _isUploading = false;

  Widget appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    ViewProfileScreen(chatUser: widget.chatUser))));
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: StreamBuilder(
            stream: APIs.getUserInfo(widget.chatUser),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final messageLists =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
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
                  const SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(deviceSize.height * 0.3),
                    child: CachedNetworkImage(
                      width: deviceSize.height * .055,
                      height: deviceSize.height * .055,
                      fit: BoxFit.cover,
                      imageUrl: messageLists.isNotEmpty
                          ? messageLists[0].image
                          : widget.chatUser.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageLists.isNotEmpty
                            ? messageLists[0].name
                            : widget.chatUser.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        messageLists.isNotEmpty
                            // ignore: unrelated_type_equality_checks
                            ? messageLists[0].isOnline == true
                                ? 'Online'
                                : FormatDateTime.getLastActiveFormattedTime(
                                    context,
                                    messageLists[0].lastActive,
                                  )
                            : FormatDateTime.getLastActiveFormattedTime(
                                context,
                                widget.chatUser.lastActive,
                              ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => VideoCallScreen())));
                    },
                    child: Image.asset(
                      'assets/images/video_call.png',
                      width: deviceSize.width * 0.09,
                      height: deviceSize.height * 0.09,
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: deviceSize.height * 0.01,
        horizontal: deviceSize.width * 0.025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blue,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Write something here...',
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: 70,
                      );
                      for (var i in images) {
                        setState(() => _isUploading = true);

                        log(i.toString());
                        APIs.sendMessageImage(
                          widget.chatUser,
                          File(i.path),
                        );
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() => _isUploading = true);

                        log(image.toString());
                        APIs.sendMessageImage(
                            widget.chatUser, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.02,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                APIs.sendMessage(
                  widget.chatUser,
                  _messageController.text,
                  Type.text,
                );
                _messageController.text = '';
              }
            },
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              size: 28,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [];
    log(widget.chatUser.toJson().toString());
    return WillPopScope(
      onWillPop: () {
        if (_showEmoji == true) {
          setState(() {
            _showEmoji = !_showEmoji;
          });
          // Does not allow user to go back
          return Future.value(true);
        } else {
          // Close the application
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.chatUser),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          messages = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          log('Message -- ${json.encode(messages)}');

                          if (messages.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageCardWidget(
                                    message: messages[index],
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hi! 👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                _isUploading == true
                    ? const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: deviceSize.height * 0.35,
                    child: EmojiPicker(
                      textEditingController: _messageController,
                      config: Config(
                        // bgColor: const Color.fromARGB(255, 218, 238, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
