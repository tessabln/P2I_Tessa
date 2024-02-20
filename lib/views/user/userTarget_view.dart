import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTargetView extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? userId;

  const UserTargetView({required this.data, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('kills')
                  .where('idKiller', isEqualTo: user!.uid)
                  .limit(1)
                  .get(),
              builder: (context, killsSnapshot) {
                if (killsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (killsSnapshot.hasError) {
                  return Center(
                      child: Text('Erreur: ${killsSnapshot.error}'));
                } else {
                  // Vérifiez si des kills ont été trouvés
                  if (killsSnapshot.data!.docs.isNotEmpty) {
                    // Récupérer l'idCible du premier kill trouvé
                    String? idCible =
                        killsSnapshot.data!.docs[0]['idCible'];
                    // Effectuer une requête pour obtenir les informations de l'utilisateur cible
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(idCible)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator());
                        } else if (userSnapshot.hasError) {
                          return Center(
                              child:
                                  Text('Erreur: ${userSnapshot.error}'));
                        } else {
                          // Si les données de l'utilisateur cible existent
                          if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            String firstname =
                                userSnapshot.data!['firstname'];
                            String lastname =
                                userSnapshot.data!['lastname'];
                            return Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Ta cible est : \n',
                                    ),
                                    TextSpan(
                                      text: '$firstname $lastname',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Aucune donnée trouvée pour l'utilisateur cible
                            return Center(
                                child: Text('Aucune cible trouvée'));
                          }
                        }
                      },
                    );
                  } else {
                    // Aucun kill trouvé
                    return Center(child: Text('Aucune cible trouvée'));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
