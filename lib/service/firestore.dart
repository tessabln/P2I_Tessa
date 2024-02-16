import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user.dart' as CustomUser;

class FirestoreService {
  // get collection
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference games =
      FirebaseFirestore.instance.collection('games');
  final CollectionReference objects =
      FirebaseFirestore.instance.collection('objects');
  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  User? user = FirebaseAuth.instance.currentUser;

  // CREATE
  static Future<void> addUser(CustomUser.User user) async {
    await _firestore.collection("users").doc(user.uid).set({
      'lastname': user.lastname,
      'firstname': user.firstname,
      'family': user.family,
      'email': user.email,
      'code': user.targetcode,
    });
  }

  addGameDetails(String name, DateTime begindate, DateTime endate) async {
    await FirebaseFirestore.instance
        .collection('games')
        .doc("CmJ2bdPfGE7SMmoG7dqh")
        .set({
      'name': name,
      'begindate': begindate,
      'endate': endate,
    });
  }

  Future<void> addObject(
      String name, String description, DateTime begindate, DateTime endate) {
    return objects.add({
      'name': name,
      'description': description,
      'begindate': begindate,
      'endate': endate,
    });
  }


  Future<void> addPost(String message){
    return posts.add({
      'PostMessage': message,
      'TimeStamp':Timestamp.now(),
    });
  }
  // READ
Stream<QuerySnapshot> getObjectStream() {
    return FirebaseFirestore.instance
        .collection('objects')
        .orderBy('begindate', descending: true)
        .snapshots();
  }
  

  Stream<QuerySnapshot> getPostsStream(){
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
      return postsStream;
  }

  // UPDATE

  // DELETE
  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      print('L utilisateur a bien été supprimé');
    } catch (error) {
      print('Echec de la suppression: $error');
    }
  }

  Future<void> deleteObject(String objId) {
    return FirebaseFirestore.instance.collection('objects').doc(objId).delete();
  }
}
