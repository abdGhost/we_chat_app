import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/login_screen.dart';
import '../dialogs/dialogs_widget.dart';
import '../models/chat_user.dart';

import '../api/api.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser chatUser;
  const ProfileScreen({
    super.key,
    required this.chatUser,
  });
  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              DialogsWidget.showProgressBar(context);
              await APIs.firebaseAuth.signOut().then((value) async {
                await APIs.updateActiveStatus(false);
                await GoogleSignIn().signOut().then(
                  (value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    APIs.firebaseAuth = FirebaseAuth.instance;

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                );
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
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
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  deviceSize.height * 0.2),
                              child: Image.file(
                                File(_image!),
                                width: deviceSize.height * .2,
                                height: deviceSize.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  deviceSize.height * 0.2),
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: _showBottomSheet,
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.03,
                  ),
                  Text(
                    widget.chatUser.email,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.03,
                  ),
                  TextFormField(
                    onSaved: (value) => APIs.me!.name = value ?? '',
                    validator: (value) => (value != null && value.isNotEmpty)
                        ? null
                        : 'Required Field',
                    initialValue: widget.chatUser.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text('Name'),
                      hintText: 'User Name',
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.03,
                  ),
                  TextFormField(
                    onSaved: (value) => APIs.me!.about = value ?? '',
                    validator: (value) => (value != null && value.isNotEmpty)
                        ? null
                        : 'Required Field',
                    initialValue: widget.chatUser.about,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.info,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text('About'),
                      hintText: 'eg. Hey, I am using We Chat',
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.04,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(
                        deviceSize.width * 0.5,
                        deviceSize.height * 0.06,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.profileUpdate().then(
                          (value) => DialogsWidget.showSnackbar(
                            context,
                            'Update Profile Successfully',
                            SnackBarBehavior.fixed,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      'Update'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
            padding: EdgeInsets.only(
              left: deviceSize.width * .03,
              top: deviceSize.height * .03,
              bottom: deviceSize.height * 0.02,
            ),
            children: [
              const Text(
                'Please Select Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize:
                          Size(deviceSize.width * 0.3, deviceSize.height * 0.3),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        APIs.updateProfileImage(File(_image!));
                      }
                    },
                    child: Image.asset(
                      'assets/images/camera.png',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize:
                          Size(deviceSize.width * 0.3, deviceSize.height * 0.3),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      'assets/images/gallery.png',
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
