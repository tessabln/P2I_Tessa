// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/userAuth.dart';
import 'package:flutter_app/models/user.dart' as User;
import 'package:flutter_app/service/firestore.dart';
import 'package:flutter_app/views/login_view.dart';

class RegisterViewModel {
  final TextEditingController userlastnameController = TextEditingController();
  final TextEditingController userfirstnameController = TextEditingController();
  final TextEditingController userfamilyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController targetcodeController = TextEditingController();



  Future<void> registerUser(BuildContext context) async {
    final String userlastname = userlastnameController.text.trim();
    final String userfirstname = userfirstnameController.text.trim();
    final String userfamily = userfamilyController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPw = confirmPwController.text.trim();
    final String targetcode = targetcodeController.text.trim();

    if (password == confirmPw) {
      try {
        final UserCredential? userCredential =
            await AuthService.register(email, password, context);

        if (userCredential != null) {
          final User.User user = User.User(
            uid: userCredential.user!.uid,
            lastname: userlastname,
            firstname: userfirstname,
            family: userfamily,
            email: email,
            targetcode: int.parse(targetcode),
          );

          await FirestoreService.addUser(user);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginView(
                onTap: () {},
              ),
            ),
          );
        }
      } catch (e) {
        print('Erreur lors de l\'inscription: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'inscription: $e'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
