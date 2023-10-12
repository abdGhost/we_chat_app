import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/api.dart';
import '../dialogs/dialogs_widget.dart';
import '../models/chat_user.dart';
import '../screens/profile_screen.dart';

import '../widgets/card_user_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> userList = [];
  final List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      print(message!);
      // If user is logged in then only call active and inactive code
      if (APIs.firebaseAuth.currentUser != null) {
        if (message.toString().contains('paused') ||
            message.toString().contains('inactive')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resumed')) {
          APIs.updateActiveStatus(true);
        }
      }

      return Future.value(message);
    });
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // For closing the textfield
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching == true) {
            setState(() {
              _isSearching = !_isSearching;
            });
            // Does not allow user to go back
            return Future.value(true);
          } else {
            // Close the application
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching == true
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email Address',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      // Search logic
                      _searchList.clear();
                      for (var i in userList) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          setState(() {
                            _searchList.add(i);
                          });
                        }
                      }
                    },
                  )
                : const Text('We Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: _isSearching == true
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(chatUser: APIs.me)));
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: FloatingActionButton(
              onPressed: _showAddUserDialog,
              child: const Icon(
                Icons.add_comment_outlined,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getAlluser(),
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
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (userList.isNotEmpty) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _isSearching == true
                            ? _searchList.length
                            : userList.length,
                        itemBuilder: (context, index) {
                          return CardUserWidget(
                            user: _isSearching
                                ? _searchList[index]
                                : userList[index],
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
        ),
      ),
    );
  }

  // Dialog for editing message
  void _showAddUserDialog() {
    String email = '';

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
                  '  Add User',
                ),
              ],
            ),
            content: TextFormField(
              maxLines: null,
              onChanged: (value) => email = value,
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
                  // APIs.updateMessage(widget.message, updateMessage);
                  DialogsWidget.showSnackbar(
                    context,
                    'User Added Successfully',
                    SnackBarBehavior.fixed,
                  );
                },
                child: const Text(
                  'Add',
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
}
