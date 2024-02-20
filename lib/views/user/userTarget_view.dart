// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/target_map.dart';

class UserTargetView extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? userId;

  const UserTargetView({required this.data, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    final String? targetId = TargetsMap.getTargetId(userId!);

    if (targetId == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Cible non trouvée'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cible",
        ),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(targetId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            String? targetLastname = snapshot.data?['lastname'];
            String? targetFirstname = snapshot.data?['firstname'];
            if (targetLastname == null || targetFirstname == null) {
              return Center(child: Text('Données de la cible non disponibles'));
            }

            // Recherche dans la collection "kills"
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('kills')
                  .where('idKiller',
                      isEqualTo: user!
                          .uid) 
                  .get(),
              builder: (context, killsSnapshot) {
                if (killsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (killsSnapshot.hasError) {
                  return Center(child: Text('Erreur: ${killsSnapshot.error}'));
                } else {
                  // Vérifiez si des kills ont été trouvés
                  if (killsSnapshot.data!.docs.isNotEmpty) {
                    // Affichez l'id_cible du premier kill trouvé (vous pouvez ajuster cela selon vos besoins)
                    String? idCible = killsSnapshot.data!.docs[0]['idCible'];
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Prénom de la cible: $targetFirstname',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Nom de la cible: $targetLastname',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'ID de la cible: $idCible',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Aucun kill trouvé
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Prénom de la cible: $targetFirstname',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Nom de la cible: $targetLastname',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Aucun kill trouvé pour cet utilisateur',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
