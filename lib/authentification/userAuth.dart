// This file contains authentication services related to Firebase authentication and user management.

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/authentification/auth.dart'; // Importing authentication view
import 'package:flutter_app/components/functions.dart'; // Importing utility functions

class AuthService {
  static FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase authentication instance

  // Method to register a new user with email and password
  static Future<UserCredential?> register(
      String email, String password, BuildContext context) async {
    // Checking if the email ends with a specific domain
    if (!email.endsWith("@ensc.fr")) {
      displayMessageToUser("Adresse e-mail non autorisée",
          context); // Displaying a message for unauthorized email domain
      return null;
    }

    // Showing a loading indicator while registration is in progress
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Creating a new user with provided email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigating to authentication view after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthView()),
      );

      return userCredential; // Returning user credential after registration
    } catch (e) {
      Navigator.pop(context); // Dismissing the loading indicator
      displayMessageToUser(e.toString(), context); // Displaying error message
      return null;
    }
  }

  // Method to log in a user with email and password
  static Future<void> logIn(
      String email, String password, BuildContext context) async {
    // Showing a loading indicator while login is in progress
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Signing in the user with provided email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Navigating to authentication view after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthView()),
      );
    } catch (e) {
      Navigator.pop(context); // Dismissing the loading indicator
      displayMessageToUser(e.toString(), context); // Displaying error message
    }
  }
}
