// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/keypad.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:flutter_app/views/login_view.dart';
import 'package:flutter_app/views/user/userTarget_view.dart';

class AccountViewComponents {
  static void showTargetDialog(BuildContext context, String userId) async {
    Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
      final user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userData = await getUserData();
      final String targetCode = userData.data()?['code'].toString() ?? '';
      final TextEditingController targetController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Entrez votre code secret"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: targetController,
                ),
                const SizedBox(height: 20),
                Keypad(controller: targetController),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),),
              ),
              TextButton(
                onPressed: () {
                  if (targetCode.trim() == targetController.text.trim()) {
                    Navigator.of(context).pop();
                    _navigateToCibleView(context, targetCode);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Code incorrect. Veuillez réessayer.'),
                      ),
                    );
                  }
                },
                child: Text("Confirmer",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),),
              ),
            ],
          );
        },
      );
    } else {
      print('Aucun utilisateur connecté');
    }
  }

  static Future<void> deleteUser(BuildContext context, String userId) async {
    final firestoreService = FirestoreService();
    try {
      await firestoreService.deleteUser(userId);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginView(
                  onTap: () {},
                )),
        (route) => false,
      );
    } catch (error) {
      print('Erreur: $error');
    }
  }

  static void confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous vraiment supprimer votre compte ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteUser(context, userId);
              },
              child: Text(
                "Supprimer",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _navigateToCibleView(BuildContext context, String targetCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserTargetView(data: {}, userId: '',),
      ),
    );
  }
}
