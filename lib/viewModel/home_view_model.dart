import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/service/firestore.dart';

class HomeViewModel {
  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService firestore = FirestoreService();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getObjectData() async {
    DateTime now = DateTime.now();

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("objects")
        .where('endate', isGreaterThanOrEqualTo: now)
        .orderBy('endate', descending: false)
        .get();

    return snapshot.docs.first;
  }

  Stream<QuerySnapshot<Object?>> getPostsStream() {
    return firestore.getPostsStream();
  }
}
