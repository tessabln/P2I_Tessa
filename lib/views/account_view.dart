import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});
  
  @override
  State<AccountView> createState() => _AccountState();
}

class _AccountState extends State<AccountView> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
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
      body: ListView(
        children: [
          const SizedBox(height: 50,),

          //profile pic
          Icon(Icons.person, size: 72,),
        ]
      )
    ); 
  }

  //Méthode pour déconnecter l'utilisateur
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }
}
