// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/keypad.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:flutter_app/views/change_pw_view.dart';
import 'package:flutter_app/views/login_view.dart';
import 'package:flutter_app/services/firestore.dart';
import 'package:flutter_app/views/user/target_view.dart';
import 'package:provider/provider.dart';

class AccountView extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          const Text("Dark mode"),
          CupertinoSwitch(
            value:
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            activeColor: Colors.grey.shade700,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(
                Icons.person,
                size: 72,
              ),
              const SizedBox(height: 100),
              MyButton(
                text: "Changer mon mot de passe",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangePasswordView();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Supprimer mon compte",
                onTap: () => _confirmDeleteUser(context, currentUser.uid),
              ),
              const SizedBox(height: 10),
              MyButton(
                text: " Voir ma cible",
                onTap: () {
                  _showTargetDialog(context);
                },
              ),
              const SizedBox(height: 120),
              GestureDetector(
                onTap: () {
                  logout(context);
                },
                child: SizedBox(
                  width: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Se déconnecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargetDialog(BuildContext context) {
    String targetCode = '12';

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
                onChanged: (value) {
                  targetCode = value;
                },
              ),
              const SizedBox(height: 20),
              Keypad(controller: _controller),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCibleView(context, targetCode);
              },
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCibleView(BuildContext context, String targetCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TargetView(targetCode: targetCode),
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

  Future<void> _deleteUser(BuildContext context, String userId) async {
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

  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous vraiment supprimer votre compte ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(context, userId);
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }
}
