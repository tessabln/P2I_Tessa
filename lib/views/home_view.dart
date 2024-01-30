import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key});

  // Méthode pour récupérer l'UID de l'utilisateur connecté
  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "Aucun utilisateur connecté";
  }

  // Méthode pour déconnecter l'utilisateur
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Vous pouvez ajouter ici une redirection vers l'écran de connexion si nécessaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          // Bouton de déconnexion
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
          // Bouton pour changer de thème
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.nightlight_round_sharp),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "(${getUserUID()})",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
