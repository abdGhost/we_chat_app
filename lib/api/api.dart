import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat_app/models/chat_user.dart';

class APIs {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorgae = FirebaseStorage.instance;

  static User? get user => firebaseAuth.currentUser;
  static ChatUser? me;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user?.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user?.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      about: 'Hey, I\'m using We Chat!',
      createdAt: time,
      email: user!.email.toString(),
      id: user!.uid,
      image: user!.photoURL.toString(),
      isOnline: 'false',
      lastActive: time,
      name: user!.displayName.toString(),
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user!.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user!.uid)
        .snapshots();
  }

  static Future<void> profileUpdate() async {
    await firestore.collection('users').doc(user?.uid).update(
      {
        'name': me?.name,
        'about': me?.about,
      },
    );
  }

  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split('.').last;

    final ref =
        firebaseStorgae.ref().child('profile_pictures/${user!.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('${p0.bytesTransferred / 1000} KB');
    });

    me!.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user!.uid)
        .update({'image': me!.image});
  }

  static getConversationId(String id) => user!.uid.hashCode <= id.hashCode
      ? '${user!.uid}_$id'
      : '${id}_${user!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      ChatUser user) {
    return APIs.firestore
        .collection('chat/${getConversationId(user.id)}/messages')
        .snapshots();
  }
}
