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
      // Si l'utilisateur n'est pas connecté, affichez un message ou redirigez vers la page de connexion
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    final String? targetId = TargetsMap.getTargetId(userId!);

    if (targetId == null) {
      // Si l'ID de la cible n'est pas trouvé dans la Map, affichez un message approprié
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
            String lastname = data['lastname'] ?? 'Nom non défini';
            String firstname = data['firstname'] ?? 'Prénom non défini';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Prénom de la cible: $firstname',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Nom de la cible: $lastname',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
