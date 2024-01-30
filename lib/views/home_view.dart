// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  // Méthode pour récupérer l'UID de l'utilisateur connecté
  /*String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "Aucun utilisateur connecté";
  }*/

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connecté en tant que : ' + user!.email!),
          ],
        ),
      ),
    );
  }
}
