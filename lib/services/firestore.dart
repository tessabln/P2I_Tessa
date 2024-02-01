import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // CREATE: add a new user
  addUserDetails(
      String uid, String lastName, String firstName, String family, String email, int targetcode) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'lastname': lastName,
      'firstname': firstName,
      'family': family,
      'email': email,
      'code': targetcode,
    });
  }


  // READ: get users from database

  // UPDATE: update users given a doc id

  // DELETE: delete users given a doc id
}


