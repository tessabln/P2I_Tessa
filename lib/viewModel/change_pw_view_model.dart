// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/functions.dart';

class ChangePasswordViewModel {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> changePassword(BuildContext context) async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      displayMessageToUser("Les mots de passe ne sont pas les mêmes", context);
      return;
    }

    try {
      // Re-authenticate the user with their current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user!.reauthenticateWithCredential(credential);

      // If re-authentication succeeds, update the password
      await user!.updatePassword(newPassword);
      // Password successfully changed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mot de passe modifié !')),
      );
    } catch (error) {
      // Handle any errors that occur during the password change process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Echec de la modification: $error')),
      );
    }
  }
}
