// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/service/firestore.dart';

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

  @override
  void initState() {
    super.initState();
    userData = getUserData();

    // Appeler d'abord la méthode pour créer et ajouter des kills
    firestore.createAndAddKills(addedUserIds).then((_) {
      // Une fois que les kills sont créés et ajoutés, appeler la méthode pour récupérer l'ordre
      fetchAndReorderKills().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> fetchAndReorderKills() async {
    QuerySnapshot killSnapshot =
        await FirebaseFirestore.instance.collection('kills').get();
    List<Map<String, dynamic>> tableKill = killSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    List<String> newListe = recupOrder(tableKill);

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

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    var userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return userSnapshot.data() as Map<String, dynamic>;
  }

  void updateUserData(int index) async {
    Map<String, dynamic> userData = await fetchUserData(liste[index]);
    setState(() {
      // Mettez à jour l'état de votre widget avec les nouvelles données de l'utilisateur
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  final Map<String, Color> familyColors = {
    'Bleue': Color.fromARGB(255, 10, 28, 112),
    'Rouge': Color.fromARGB(255, 182, 31, 26),
    'Verte': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Jaune': Color.fromARGB(255, 215, 187, 65),
  };

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant que les données sont chargées
    } else {
      return Scaffold(
        body: ReorderableListView.builder(
          itemCount: liste.length,
          itemBuilder: (context, index) {
            if (liste[index] != null &&
                listeUserData[index] != null &&
                index < listeUserData.length) {
              Map<String, dynamic> userData = listeUserData[index];
              String lastname = userData['lastname'] ?? 'Nom non défini';
              String firstname = userData['firstname'] ?? 'Prénom non défini';
              Color textColor = userData["textColor"] ?? Colors.transparent;
              String userId = liste[index]; // récupérer l'ID de l'utilisateur

              return Card(
                key: ValueKey<String>(
                    userId), // utiliser l'ID de l'utilisateur comme clé
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
              return Container(); // retourner un conteneur vide si l'index est invalide
            }
          },
          onReorder: (oldIndex, newIndex) => updateKill(oldIndex, newIndex),
        ),
      );
    }
  }
}
// def set_order(la liste):
//   for i in range(len(liste)):
//     if i == len(liste)-1:
//       new kill(idkiller = liste[i], idCible = liste[i+1])
//     else:
//       new kill(idKiller = liste[i], idCible = liste[0])
 
//  Tous les kills en cours deviennent etat échec
//  Ajout des nouveaux kills avec état en cours



// def validation_kill(killCompleted):
//   recup kill.idCible where kill.idKiller == killCompleted.idCible
//   create new kill(idKiller == killCompleted.idKiller, idCible == kill.idCible)

//   killCompleted.etat = success























// La table kill récupérée ici c'est que les kills en cours

// def recup_order(table tableKill):
//  liste  = new list()
//   liste.add(tableKill[0].idKiller)
//   string lastCible = tableKill[0].idCible

//   while(lastCible != liste[0]):
//     kill = tableKill.where(idKiller == lastCible)
//     liste.add(kill.idKiller)
//     lastCible = kill.idCible
//   On obtient une liste d'id utilisateur classé par ordre killer cible