// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/auth/auth.dart';
import 'package:flutter_app/components/functions.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> register(
      String email, String password, BuildContext context) async {
    // Vérifie si l'email se termine par "@ensc.fr"
    if (!email.endsWith("@ensc.fr")) {
      displayMessageToUser("Adresse e-mail non autorisée", context);
      return null;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthView()),
      );

      return userCredential;
    } catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.toString(), context);
      return null;
    }
  }

  static Future<void> logIn(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthView()),
      );
    } catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.toString(), context);
    }
  }
}
