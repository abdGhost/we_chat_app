import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/api/api.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userList = [];
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
          onPressed: () {},
          child: const Icon(
            Icons.add_comment_outlined,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              userList.add(i.data()['name']);
              print(i.data());
            }
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                // return const CardUserWidget();
                return Text('Name ${userList[index]}');
              });
        },
      ),
    );
  }
}
