import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

