import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/account_components.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/functions.dart';
import 'package:flutter_app/views/change_pw_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/theme/theme_provider.dart';

class AccountView extends StatelessWidget {
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
                onTap: () => AccountViewComponents.confirmDeleteUser(
                    context, currentUser.uid),
              ),
              const SizedBox(height: 10),
              MyButton(
                text: " Voir ma cible",
                onTap: () {
                  AccountViewComponents.showTargetDialog(
                      context, currentUser.uid);
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
}