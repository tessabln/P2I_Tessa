import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/kill.dart';
import 'package:flutter_app/views/login_view.dart';


// display error message to user
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}

void logout(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => LoginView(
              onTap: () {},
            )),
  );
}

void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmation"),
        content: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler",
            style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),),
          ),
          TextButton(
            onPressed: () {
              logout(context);
            },
            child: Text("Confirmer",
            style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),),
          ),
        ],
      ),
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
            .get();

        if (killQuery.docs.isNotEmpty) {
          String killId = killQuery.docs.first.id;

          // Mettre à jour l'état du kill
          await FirebaseFirestore.instance
              .collection('kills')
              .doc(killId)
              .update({
            'etat': KillState.succes.name,
          });

          // Mettre à jour la notification pour la marquer comme confirmée
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

        // Mettre à jour l'état du kill à "enCours"
        await FirebaseFirestore.instance
            .collection('kills')
            .doc(killId)
            .update({
          'etat': KillState.enCours.name,
        });

        // Mettre à jour la notification pour la marquer comme refusée
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



