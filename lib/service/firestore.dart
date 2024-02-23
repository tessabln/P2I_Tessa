// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/kill.dart';
import 'package:flutter_app/models/user.dart' as CustomUser;

class FirestoreService {
  // get collection
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference games =
      FirebaseFirestore.instance.collection('games');
  final CollectionReference objects =
      FirebaseFirestore.instance.collection('objects');
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference killsCollection =
      FirebaseFirestore.instance.collection('kills');
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

  Future<void> addPost(String message) {
    return posts.add({
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  void addOrUpdateKills(List<Kill> kills) async {
    try {
      for (var kill in kills) {
        // Vérifier si un kill avec le même idKiller existe déjà
        bool existingKill = await checkExistingKill(kill.idKiller);

        if (existingKill) {
          // Si un kill avec le même idKiller existe déjà, mettez à jour son état au lieu d'en ajouter un nouveau
          await updateKill(kill);
          print('Kill mis à jour pour idKiller ${kill.idKiller}');
        } else {
          // Sinon, ajoutez le nouveau kill
          await addNewKill(kill);
          print('Nouveau kill ajouté pour idKiller ${kill.idKiller}');
        }
      }
    } catch (e) {
      print('Erreur lors de l\'ajout/mise à jour du kill dans Firestore: $e');
    }
  }

  Future<bool> checkExistingKill(String idKiller) async {
    // Recherchez un kill avec le même idKiller dans la base de données
    QuerySnapshot query = await killsCollection
        .where('idKiller', isEqualTo: idKiller)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> updateKill(Kill kill) async {
    // Mettez à jour le kill existant avec le même idKiller
    await killsCollection.doc(kill.idKiller).update({
      'etat': kill.etat.toString(),
      // Ajoutez d'autres champs à mettre à jour si nécessaire
    });
  }

  Future<void> addNewKill(Kill kill) async {
    // Ajoutez un nouveau kill dans la base de données
    await killsCollection.doc(kill.id).set({
      'id': kill.id,
      'idKiller': kill.idKiller,
      'idCible': kill.idCible,
      'etat': kill.etat.toString(),
      // Ajoutez d'autres champs si nécessaire
    });
  }

  // READ
  Stream<QuerySnapshot> getObjectStream() {
    return FirebaseFirestore.instance
        .collection('objects')
        .orderBy('begindate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsStream() {
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

  Future<void> deleteAllPlayers() async {
    await FirebaseFirestore.instance.collection('users').get().then(
      (snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );
  }

  Future<void> deleteAllPosts() async {
    await FirebaseFirestore.instance.collection('posts').get().then(
      (snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );
  }

  Future<void> deleteAllObjects() async {
    await FirebaseFirestore.instance.collection('objects').get().then(
      (snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );
  }
}
