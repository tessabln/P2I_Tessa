// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference kills =
      FirebaseFirestore.instance.collection('kills');

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

  Future<void> createAndAddKills() async {
  QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('lastname')
      .get();

  List<QueryDocumentSnapshot> userList = usersSnapshot.docs;
  int userListLength = userList.length;

  for (int i = 0; i < userListLength; i++) {
    String idKiller = userList[i].id;
    String idCible = userList[(i + 1) % userListLength].id;

    // Récupérez les informations sur le tueur et la cible
    DocumentSnapshot killerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(idKiller)
        .get();
    DocumentSnapshot cibleDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(idCible)
        .get();

    // Récupérez les familles du tueur et de la cible
    String killerFamily = killerDoc['family'];
    String cibleFamily = cibleDoc['family'];

    // Vérifiez si les familles sont identiques
    if (killerFamily == cibleFamily) {
      // Les joueurs appartiennent à la même famille, passez à l'itération suivante
      continue;
    }

    // Créez un objet Kill avec les données appropriées
    Kill kill = Kill(
      idKiller: idKiller,
      idCible: idCible,
      etat: KillState.enCours,
    );

    // Convertir l'objet Kill en une Map<String, dynamic>
    Map<String, dynamic> killData = kill.toJson();

    // Ajoutez les données converties en Map à Firestore
    await kills.add(killData);
  }
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
