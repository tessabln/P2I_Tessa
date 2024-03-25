// ignore_for_file: library_prefixes, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/kill.dart';
import 'package:flutter_app/models/user.dart' as CustomUser;
import 'package:flutter_app/models/user.dart';

class FirestoreService {
  // get collections
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
      'status': user.status.stringValue,
      'nbKills': user.nbkills,
    });
  }

  addKillsToFamily(String idKiller) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(idKiller)
        .get();
    var userData = userSnapshot.data() as Map<String, dynamic>;
    var family = userData['family'];

    updateFamilyKills(family, 1);
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

  Future<void> addPost(String message) {
    return posts.add({
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  Future<void> createAndAddKills(List<String> addedUserIds) async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastname', descending: false)
        .get();
    List<String> userIds = usersSnapshot.docs.map((doc) => doc.id).toList();

    for (int i = 0; i < userIds.length; i++) {
      String idKiller = userIds[i];
      String idCible = userIds[(i + 1) % userIds.length];

      bool killExists = await checkIfKillExists(idKiller, idCible);

      if (!killExists) {
        Kill kill = Kill(
          idKiller: idKiller,
          idCible: idCible,
          etat: KillState.enCours,
        );

        Map<String, dynamic> killData = kill.toJson();

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

  Future<bool> checkIfKillsCreated() async {
    final snapshot = await FirebaseFirestore.instance.collection('kills').get();
    bool temp = true;
    if (snapshot.size == 0) {
      temp = false;
    }
    return temp;
  }

  // READ

  Future<int> getUserKills(String userId) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userData.data()?['nbKills'] ?? 0;
  }

  Stream<QuerySnapshot> getObjectStream() {
    return FirebaseFirestore.instance
        .collection('objects')
        .orderBy('begindate', descending: true)
        .snapshots();
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

  Future<int> getFamilyKills(String color) async {
    var familyQuery = await FirebaseFirestore.instance
        .collection('families')
        .where("color", isEqualTo: color)
        .get();

    if (familyQuery.docs.isNotEmpty) {
      var familyData = familyQuery.docs.first.data();
      return familyData['nbKills'] ?? 0;
    } else {
      throw Exception('Famille non trouvée pour la couleur spécifiée');
    }
  }

  Future<int> getLifeCountForFamily(String family) async {
    int deathCount = 0;
    var users = await FirebaseFirestore.instance.collection('users').get();

    for (var user in users.docs) {
      var status = user['status'];
      var userFamily = user['family'];

      if (status == 'vivant' && userFamily == family) {
        deathCount++;
      }
    }

    return deathCount;
  }

  Future<int> getBestKillerForFamily(String family) async {
    int maxKills = 0;

    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('family', isEqualTo: family)
        .get();

    for (var userDoc in users.docs) {
      var nbKills = userDoc['nbKills'];
      if (nbKills > maxKills) {
        maxKills = nbKills;
      }
    }

    return maxKills;
  }

  // UPDATE

  Stream<QuerySnapshot> listenToNotifications(String userId) {
    final CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    return notifications
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> setOrder(BuildContext context, List<String> liste) async {
    for (int i = 0; i < liste.length; i++) {
      String idKiller = liste[i];
      String idCible;
      if (i == liste.length - 1) {
        idCible = liste[0];
      } else {
        idCible = liste[i + 1];
      }

      QuerySnapshot querySnapshot =
          await kills.where('idKiller', isEqualTo: idKiller).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs[0].reference;
        await docRef.update({
          'idCible': idCible,
        });
      } else {
        await kills.add({
          'idKiller': idKiller,
          'idCible': idCible,
        });
      }
    }

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

  Future<void> confirmDeath(String notifId) async {
    DocumentSnapshot notificationSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notifId)
        .get();

    if (notificationSnapshot.exists) {
      Map<String, dynamic>? notificationData =
          notificationSnapshot.data() as Map<String, dynamic>?;

      if (notificationData != null && notificationData.containsKey('userId')) {
        String userId = notificationData['userId'];

        QuerySnapshot killQuery = await FirebaseFirestore.instance
            .collection('kills')
            .where('idCible', isEqualTo: userId)
            .where('etat', isEqualTo: 'enValidation')
            .get();

        QuerySnapshot killToPassQuery = await FirebaseFirestore.instance
            .collection('kills')
            .where('idKiller', isEqualTo: userId)
            .where('etat', isEqualTo: 'enCours')
            .get();

        if (killQuery.docs.isNotEmpty) {
          DocumentSnapshot killDoc = killQuery.docs.first;
          DocumentSnapshot killToPassDoc = killToPassQuery.docs.first;
          String killId = killDoc.id;
          String killToPassId = killToPassDoc.id;

          await addKillsToFamily(killDoc['idKiller']);

          await FirebaseFirestore.instance
              .collection('kills')
              .doc(killId)
              .update({
            'etat': KillState.succes.name,
          });

          await FirebaseFirestore.instance
              .collection('kills')
              .doc(killToPassId)
              .update({
            'etat': KillState.echec.name,
          });

          Kill kill = Kill(
            idKiller: killDoc['idKiller'],
            idCible: killToPassDoc['idCible'],
            etat: KillState.enCours,
          );

          Map<String, dynamic> killData = kill.toJson();

          await kills.add(killData);

          await FirebaseFirestore.instance
              .collection('notifications')
              .doc(notifId)
              .update({
            'confirmed': true,
          });

          print('La mort a été confirmée avec succès.');
        } else {
          print('Aucun kill trouvé pour cet utilisateur.');
        }
      }
    }
  }

  Future<void> rejectDeath(String notifId) async {
    DocumentSnapshot notificationSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notifId)
        .get();

    if (notificationSnapshot.exists) {
      Map<String, dynamic>? notificationData =
          notificationSnapshot.data() as Map<String, dynamic>?;

      if (notificationData != null && notificationData.containsKey('userId')) {
        String userId = notificationData['userId'];

        QuerySnapshot killQuery = await FirebaseFirestore.instance
            .collection('kills')
            .where('idCible', isEqualTo: userId)
            .get();

        if (killQuery.docs.isNotEmpty) {
          String killId = killQuery.docs.first.id;

          await FirebaseFirestore.instance
              .collection('kills')
              .doc(killId)
              .update({
            'etat': KillState.enCours.name,
          });

          await FirebaseFirestore.instance
              .collection('notifications')
              .doc(notifId)
              .update({
            'rejected': true,
          });

          print('Le refus de la mort a été enregistré avec succès.');
        } else {
          print('Aucun kill trouvé pour cet utilisateur.');
        }
      }
    }
  }

  Future<void> death(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'status': UserStatus.mort.stringValue});
    } catch (error) {
      print('Erreur lors de la confirmation de la mort: $error');
    }
  }

  Future<void> updateFamilyKills(String color, int nbKills) async {
    var family = await FirebaseFirestore.instance
        .collection('families')
        .where("color", isEqualTo: color)
        .get();
    var familyId = family.docs.first.id;

    await FirebaseFirestore.instance
        .collection('families')
        .doc(familyId)
        .update({
      'nbKills': FieldValue.increment(nbKills),
    });
  }

  Future<void> updateNbKillsForUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          int currentNbKills =
              userData.containsKey('nbKills') ? userData['nbKills'] : 0;
          int updatedNbKills = currentNbKills + 1;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'nbKills': updatedNbKills});
        }
      }
    } catch (error) {
      print(
          'Erreur lors de la mise à jour du champ nbKills pour l\'utilisateur : $error');
    }
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
