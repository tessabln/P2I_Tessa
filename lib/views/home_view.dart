import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.grey,
        actions: [
          // logout button
          /*IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),*/
          // theme button
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); // Correction ici
            },
            icon: Icon(Icons.nightlight_round_sharp),
          ),
        ],
      ),
    );
  }
}
