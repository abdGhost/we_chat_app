import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat_app/models/chat_user.dart';

class APIs {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User? get user => firebaseAuth.currentUser;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user?.uid).get()).exists;
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
}
