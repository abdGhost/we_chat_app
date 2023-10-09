import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/helpers/format_date_time.dart';

import '../auth/login_screen.dart';
import '../dialogs/dialogs_widget.dart';
import '../models/chat_user.dart';

import '../api/api.dart';
import '../main.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser chatUser;
  const ViewProfileScreen({
    super.key,
    required this.chatUser,
  });
  @override
  State<ViewProfileScreen> createState() {
    return _ViewProfileScreenState();
  }
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined On: ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              FormatDateTime.getLastMessageFormatedTime(
                context,
                widget.chatUser.createdAt,
                true,
              ),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.06),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: deviceSize.width,
                  height: deviceSize.height * 0.03,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(deviceSize.height * 0.2),
                      child: CachedNetworkImage(
                        width: deviceSize.height * .2,
                        height: deviceSize.height * .2,
                        fit: BoxFit.cover,
                        imageUrl: widget.chatUser.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                Text(
                  widget.chatUser.email,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.chatUser.about,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
