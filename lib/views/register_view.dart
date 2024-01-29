// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/helper/helper_functions.dart';

class RegisterView extends StatefulWidget {
  final void Function()? onTap;

  const RegisterView({super.key, required this.onTap});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // text controllers
  final TextEditingController userlastnameController = TextEditingController();
  final TextEditingController userfirstnameController = TextEditingController();
  final TextEditingController userfamilyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  //register method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Les mots de passe ne sont pas les mêmes", context);
    }

    // if password do match
    else {
      // try creating the user
    try {
      // create the user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // display error message to user
      displayMessageToUser(e.code, context);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.gps_fixed,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 25),

              // app name
              Text(
                "T H E  K I L L E R",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 50),

              // userlastname textfield
              MyTextField(
                  hintText: "Nom",
                  obscureText: false,
                  controller: userlastnameController),

              const SizedBox(height: 10),

              // userlastname textfield
              MyTextField(
                  hintText: "Prénom",
                  obscureText: false,
                  controller: userfirstnameController),

              const SizedBox(height: 10),

              // userfamily textfield
              MyTextField(
                  hintText: "Famille",
                  obscureText: false,
                  controller: userfamilyController),

              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),

              const SizedBox(height: 10),

              // password textfiel
              MyTextField(
                  hintText: "Mot de passe",
                  obscureText: true,
                  controller: passwordController),

              const SizedBox(height: 10),

              // confirm password textfiel
              MyTextField(
                  hintText: "Confirmer le mot de passe",
                  obscureText: true,
                  controller: confirmPwController),

              const SizedBox(height: 10),
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // register button
              MyButton(
                text: "S'inscrire",
                onTap: registerUser,
              ),

              const SizedBox(height: 25),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous avez déjà un compte ?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Connectez-vous ici",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
