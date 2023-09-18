import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat_app/api/api.dart';
import 'package:we_chat_app/models/chat_user.dart';

import '../widgets/card_user_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> userList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('We Chat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.firebaseAuth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(
            Icons.add_comment_outlined,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              userList =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (userList.isNotEmpty) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return CardUserWidget(
                        user: userList[index],
                      );
                    });
              } else {
                return const Center(
                  child: Text(
                    'No Connection Found',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
