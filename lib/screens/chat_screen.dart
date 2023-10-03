import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/models/chat_user.dart';
import 'package:we_chat_app/models/message.dart';
import 'package:we_chat_app/widgets/message_card_widget.dart';

import '../main.dart';
import '../widgets/card_user_widget.dart';

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
    return InkWell(
      onTap: () {},
      child: Padding(
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
            const SizedBox(
              width: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(deviceSize.height * 0.3),
              child: CachedNetworkImage(
                width: deviceSize.height * .055,
                height: deviceSize.height * .055,
                fit: BoxFit.cover,
                imageUrl: widget.chatUser.image,
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
                  widget.chatUser.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Last seen not avaiable',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blue,
                      size: 25,
                    ),
                  ),
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write something here...',
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
            onPressed: () {},
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
    print(widget.chatUser.toJson());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                // stream: APIs.getAlluser(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      // final data = snapshot.data?.docs;

                      // userList = data
                      //         ?.map((e) => ChatUser.fromJson(e.data()))
                      //         .toList() ??
                      //     [];

                      messages.add(
                        Message(
                            toId: 'zyz',
                            fromId: APIs.user!.uid,
                            message: 'Hiiiii',
                            read: '',
                            type: Type.text,
                            sent: '12 PM'),
                      );
                      messages.add(
                        Message(
                            toId: APIs.user!.uid,
                            fromId: 'xyz',
                            message: 'Hi',
                            read: '',
                            type: Type.text,
                            sent: '12 PM'),
                      );

                      if (messages.isNotEmpty) {
                        return ListView.builder(
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
            _chatInput(),
          ],
        ),
      ),
    );
  }
}
