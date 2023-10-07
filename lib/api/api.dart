import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/chat_user.dart';

import '../models/message.dart';

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user!.uid).update({
      'is_online': isOnline,
      'last-active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
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
      log('${p0.bytesTransferred / 1000} KB');
    });

    me!.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user!.uid)
        .update({'image': me!.image});
  }

  // useful for getting conversation id
  static String getConversationID(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user!.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        message: msg,
        read: '',
        type: type,
        fromId: user!.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //Update Message read status
  static Future<void> updateMessageReadStatus(Message message) {
    return firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageSeen(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendMessageImage(ChatUser user, File file) async {
    final ext = file.path.split('.').last;

    final ref = firebaseStorgae.ref().child(
        'images/${getConversationID(user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('${p0.bytesTransferred / 1000} KB');
    });

    final imageUrl = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.id)
        .update({'image': me!.image});
    await sendMessage(user, imageUrl, Type.image);
  }
}
