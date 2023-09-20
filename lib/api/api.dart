import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat_app/models/chat_user.dart';

class APIs {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User? get user => firebaseAuth.currentUser;
  static late ChatUser me;

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
        'name': me.name,
        'about': me.about,
      },
    );
  }
}
