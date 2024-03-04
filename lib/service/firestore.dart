// ignore_for_file: library_prefixes, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final user = FirebaseAuth.instance.currentUser;
  List<String> liste = [];
  List<Map<String, dynamic>> listeUserData = [];

  get familyColors => null;

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

  Future<void> createAndAddKills(List<String> addedUserIds) async {
    // Récupérer la liste de tous les identifiants d'utilisateurs
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastname', descending: false)
        .get();
    List<String> userIds = usersSnapshot.docs.map((doc) => doc.id).toList();

    // Associer chaque joueur à un autre joueur en tant que cible
    for (int i = 0; i < userIds.length; i++) {
      String idKiller = userIds[i];
      String idCible = userIds[(i + 1) % userIds.length];

      // Vérifier si ce kill existe déjà dans la base de données
      bool killExists = await checkIfKillExists(idKiller, idCible);

      // Si le kill n'existe pas déjà, l'ajouter à la base de données
      if (!killExists) {
        // Créer un objet Kill avec les données appropriées
        Kill kill = Kill(
          idKiller: idKiller,
          idCible: idCible,
          etat: KillState.enCours,
        );

        // Convertir l'objet Kill en une Map<String, dynamic>
        Map<String, dynamic> killData = kill.toJson();

        // Ajouter les données converties en Map à Firestore
        await kills.add(killData);
      }
    }
  }

  Future<bool> checkIfKillExists(String idKiller, String idCible) async {
    QuerySnapshot killSnapshot = await kills
        .where('idKiller', isEqualTo: idKiller)
        .where('idCible', isEqualTo: idCible)
        .get();

    return killSnapshot.docs.isNotEmpty;
  }

  List<String> recupOrder(List<Map<String, dynamic>> tableKill) {
    liste.add(tableKill[0]['idKiller']);
    String lastCible = tableKill[0]['idCible'];
    while (lastCible != liste[0]) {
      Map<String, dynamic>? kill = tableKill.firstWhere(
        (kill) => kill['idKiller'] == lastCible,
      );

      liste.add(kill['idKiller']);
      lastCible = kill['idCible'];
    }
    return liste;
  }

  // READ
  Stream<QuerySnapshot> getObjectStream() {
    return FirebaseFirestore.instance
        .collection('objects')
        .orderBy('begindate', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
    return postsStream;
  }

  // UPDATE

  Future<void> setOrder(BuildContext context, List<String> liste) async {
    for (int i = 0; i < liste.length; i++) {
      String idKiller = liste[i];
      String idCible;
      if (i == liste.length - 1) {
        idCible = liste[0];
      } else {
        idCible = liste[i + 1];
      }

      // Vérifier si un document avec l'idKiller existe déjà
      QuerySnapshot querySnapshot =
          await kills.where('idKiller', isEqualTo: idKiller).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Mettre à jour le document existant
        DocumentReference docRef = querySnapshot.docs[0].reference;
        await docRef.update({
          'idCible': idCible,
        });
      } else {
        // Ajouter un nouveau document
        await kills.add({
          'idKiller': idKiller,
          'idCible': idCible,
        });
      }
    }

    // afficher une boîte de dialogue pour confirmer que les déplacements ont été enregistrés avec succès
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déplacements enregistrés'),
          content: Text('Les déplacements ont été enregistrés avec succès.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
