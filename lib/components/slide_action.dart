// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/kill.dart';
import 'package:flutter_app/views/user/home_view.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideActionWidget extends StatelessWidget {
  final VoidCallback onSubmit;

  const SlideActionWidget({
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      innerColor: const Color.fromARGB(255, 72, 57, 117),
      outerColor: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      sliderButtonIcon: Icon(Icons.gps_fixed_rounded,
          color: Color.fromARGB(255, 255, 255, 255)),
      text: '              Glisser pour confirmer votre kill !',
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      sliderRotate: false,
      onSubmit: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirmer le kill"),
              content: Text("Êtes-vous sûr de vouloir confirmer votre kill ?"),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Annuler",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "Confirmer",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  onPressed: () async {
                    await firestore.updateNbKillsForUser(user!.uid);
                    await _validateKill(context);
                    Navigator.of(context).pop();

                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Notification à ta cible envoyée !"),
                          content: Text(
                              "Ta cible va pouvoir confirmer ou refuser ton kill"),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _validateKill(BuildContext context) async {
    String? targetUserId;

    QuerySnapshot killsSnapshot = await FirebaseFirestore.instance
        .collection('kills')
        .where('idKiller', isEqualTo: user?.uid)
        .where('etat', isEqualTo: 'enCours')
        .limit(1)
        .get();

    if (killsSnapshot.docs.isNotEmpty) {
      targetUserId = killsSnapshot.docs[0]['idCible'];
    }

    if (targetUserId != null) {
      QuerySnapshot querySnapshot = await kills
          .where('idKiller', isEqualTo: user?.uid)
          .where('idCible', isEqualTo: targetUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs[0];

        await docSnapshot.reference.update({
          'etat': KillState.enValidation.name,
        });

        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': targetUserId,
          'message': 'Tu a été tué !',
          'timestamp': currentTimestamp,
          'confirmed': false,
        });
      }
    }
  }
}
