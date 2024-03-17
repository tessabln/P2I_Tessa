// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/service/firestore.dart';

class OngoingKillList extends StatefulWidget {
  @override
  _KillListState createState() => _KillListState();
}

class _KillListState extends State<OngoingKillList> {
  final user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;
  final FirestoreService firestore = FirestoreService();
  final CollectionReference kills =
      FirebaseFirestore.instance.collection('kills');

  List<String> addedUserIds = [];
  List<String> liste = [];
  List<Map<String, dynamic>> listeUserData = [];
  bool isLoading = true;

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
        await FirebaseFirestore.instance.collection('kills')
        .where('etat', isEqualTo: 'enCours')
        .get();
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

    firestore.checkIfKillsCreated().then((value) {
      if (!value) {
        firestore.createAndAddKills(addedUserIds).then((_) {
          fetchAndReorderKills().then((_) {
            setState(() {
              isLoading = false;
            });
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Kills en cours"),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              itemCount: liste.length,
              itemBuilder: (context, index) {
                if (index < listeUserData.length) {
                  Map<String, dynamic> userData = listeUserData[index];
                  String lastname = userData['lastname'] ?? 'Nom non défini';
                  String firstname =
                      userData['firstname'] ?? 'Prénom non défini';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firestore.setOrder(context, liste);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}