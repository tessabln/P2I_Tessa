// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KillList extends StatefulWidget {
  @override
  _KillListState createState() => _KillListState();
}

class _KillListState extends State<KillList> {
  final user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;
  final FirestoreService firestore = FirestoreService();
  final CollectionReference kills =
      FirebaseFirestore.instance.collection('kills');

  List<String> addedUserIds = [];
  List<String> liste = [];
  List<Map<String, dynamic>> listeUserData = [];
  bool isLoading = true;

  Future<bool> checkIfKillsCreated() async {
    final snapshot = await FirebaseFirestore.instance.collection('kills').get();
    bool temp = true;
    if (snapshot.size == 0){
      temp = false;
    }
    return temp;
  }

  Future<void> setKillsCreated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('killsCreated', true);
  }

  void updateKill(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      final kill = liste.removeAt(oldIndex);
      final userData = listeUserData.removeAt(oldIndex);

      liste.insert(newIndex, kill);
      listeUserData.insert(newIndex, userData);
    });
  }

  Future<void> fetchAndReorderKills() async {
    QuerySnapshot killSnapshot =
        await FirebaseFirestore.instance.collection('kills').get();
    List<Map<String, dynamic>> tableKill = killSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    List<String> newListe = firestore.recupOrder(tableKill);

    setState(() {
      liste = newListe;
      listeUserData = [];
    });

    for (var i = 0; i < newListe.length; i++) {
      Map<String, dynamic> newData = {};
      var userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(newListe[i])
          .get();
      var userData = userSnapshot.data() as Map<String, dynamic>;
      newData["lastname"] = userData['lastname'] ?? 'Nom non défini';
      newData["firstname"] = userData['firstname'] ?? 'Prénom non défini';
      String family = userData['family'] ?? '';
      newData["textColor"] = familyColors[family] ?? Colors.transparent;
      setState(() {
        listeUserData.add(newData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userData = firestore.getUserData();

    checkIfKillsCreated().then((value) {
      if (!value) {
        firestore.createAndAddKills(addedUserIds).then((_) {
          fetchAndReorderKills().then((_) {
            setState(() {
              isLoading = false;
            });
            setKillsCreated();
          });
        });
      } else {
        fetchAndReorderKills().then((_) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }

  final Map<String, Color> familyColors = {
    'Bleue': Color.fromARGB(255, 10, 28, 112),
    'Rouge': Color.fromARGB(255, 182, 31, 26),
    'Verte': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Jaune': Color.fromARGB(255, 215, 187, 65),
  };

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            firestore.setOrder(context, liste);
          },
          child: Icon(Icons.check),
        ),
        body: ReorderableListView.builder(
          itemCount: liste.length,
          itemBuilder: (context, index) {
            if (index < listeUserData.length) {
              Map<String, dynamic> userData = listeUserData[index];
              String lastname = userData['lastname'] ?? 'Nom non défini';
              String firstname = userData['firstname'] ?? 'Prénom non défini';
              Color textColor = userData["textColor"] ?? Colors.transparent;
              String userId = liste[index];

              return Card(
                key: ValueKey<String>(userId),
                elevation: 1,
                child: ListTile(
                  title: Text(
                    '$lastname $firstname',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  trailing: const Icon(Icons.drag_handle),
                  onTap: () {},
                ),
              );
            } else {
              return Container();
            }
          },
          onReorder: (oldIndex, newIndex) => updateKill(oldIndex, newIndex),
        ),
      );
    }
  }
}
