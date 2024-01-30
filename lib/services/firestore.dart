import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // CREATE: add a new user
  //Future<void> addUser()
  // READ: get users from database

  // UPDATE: update users given a doc id

  // DELETE: delete users given a doc id
}
