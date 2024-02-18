import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/components/target_map.dart';
import 'package:flutter_app/models/kill.dart';

class TargetsView extends StatefulWidget {
  @override
  State<TargetsView> createState() => _TargetsViewState();
}

class _TargetsViewState extends State<TargetsView> {
  final user = FirebaseAuth.instance.currentUser;

  // Liste des couleurs par famille
  final Map<String, Color> familyColors = {
    'Bleue': Color.fromARGB(255, 27, 47, 135),
    'Rouge': Color.fromARGB(255, 182, 31, 26),
    'Verte': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Jaune': Color.fromARGB(255, 215, 187, 65),
  };

  // Liste des utilisateurs avec le bon ordre de "kills"
  List<DocumentSnapshot> orderedUsersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cibles"),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Récupération de la liste des utilisateurs
            List<DocumentSnapshot> usersList = snapshot.data!.docs;

            // Génération de la liste des "kills" dans l'ordre souhaité
            List<Kill> kills = generateKills(usersList);

            // Création d'une liste ordonnée des utilisateurs selon les "kills"
            orderedUsersList = [];
            for (var kill in kills) {
              var killer = usersList.firstWhere(
                (user) => user.id == kill.idKiller,
              );
              var target = usersList.firstWhere(
                (user) => user.id == kill.idCible,
              );

              // Ajouter l'ID de la cible à la Map pour cet utilisateur (killer)
              if (killer != null && target != null) {
                TargetsMap.updateTargets({killer.id: target.id});
              }

              if (killer != null) orderedUsersList.add(killer);
              if (target != null) orderedUsersList.add(target);
            }
            return ReorderableListView.builder(
              itemCount: orderedUsersList.length,
              itemBuilder: (context, index) {
                String lastname =
                    orderedUsersList[index]['lastname'] ?? 'Nom non défini';
                String firstname =
                    orderedUsersList[index]['firstname'] ?? 'Prénom non défini';
                String family = orderedUsersList[index]['family'] ?? '';

                Color backgroundColor =
                    familyColors[family] ?? Colors.transparent;

                return Container(
                  key: ValueKey(orderedUsersList[index].id),
                  color: backgroundColor,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$lastname $firstname',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {},
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
