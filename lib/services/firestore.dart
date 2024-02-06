import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference games =
      FirebaseFirestore.instance.collection('games');
  final CollectionReference objects =
      FirebaseFirestore.instance.collection('objects');
  // CREATE
  addUserDetails(String uid, String lastName, String firstName, String family,
      String email, int targetcode) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'lastname': lastName,
      'firstname': firstName,
      'family': family,
      'email': email,
      'code': targetcode,
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

  Future<void> addObject(String name, String description, DateTime begindate, DateTime endate) {
    return objects.add({
      'name': name,
      'description': description,
      'begindate': begindate,
      'endate': endate,
    });
  }

  // READ

  Stream<QuerySnapshot> getObjectsStream() {
    final objectsStream = objects.orderBy('date', descending: true).snapshots();
    return objectsStream;
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
  
}
