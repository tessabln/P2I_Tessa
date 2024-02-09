// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/auth/userAuth.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/models/user.dart' as User;
import 'package:flutter_app/services/firestore.dart';
import 'package:flutter_app/views/login_view.dart';

class RegisterView extends StatefulWidget {
  final void Function()? onTap;

  const RegisterView({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _userlastnameController = TextEditingController();
  final TextEditingController _userfirstnameController =
      TextEditingController();
  final TextEditingController _userfamilyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _targetcodeController = TextEditingController();

  @override
  void dispose() {
    _userlastnameController.dispose();
    _userfirstnameController.dispose();
    _userfamilyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
    _targetcodeController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    final String userlastname = _userlastnameController.text.trim();
    final String userfirstname = _userfirstnameController.text.trim();
    final String userfamily = _userfamilyController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPw = _confirmPwController.text.trim();
    final String targetcode = _targetcodeController.text.trim();

    if (password == confirmPw) {
      try {
        final UserCredential userCredential =
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
        // Afficher un message d'erreur en cas d'erreur lors de l'enregistrement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'inscription'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      // Afficher un message d'erreur si les mots de passe ne correspondent pas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas.'),
          duration: Duration(seconds: 5),
        ),
      );
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
              Container(
                width: 121,
                height: 124,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // app name
              Text(
                "T H E  K I L L E R",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 30),

              // userlastname textfield
              MyTextField(
                  hintText: "Nom",
                  obscureText: false,
                  controller: _userlastnameController),

              const SizedBox(height: 10),

              // userlastname textfield
              MyTextField(
                  hintText: "Prénom",
                  obscureText: false,
                  controller: _userfirstnameController),

              const SizedBox(height: 10),

              // userfamily textfield
              MyTextField(
                  hintText: "Famille",
                  obscureText: false,
                  controller: _userfamilyController),

              const SizedBox(height: 10),

              // targetcode textfield
              MyTextField(
                  hintText: "Code",
                  obscureText: true,
                  controller: _targetcodeController),

              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController),

              const SizedBox(height: 10),

              // password textfiel
              MyTextField(
                  hintText: "Mot de passe",
                  obscureText: true,
                  controller: _passwordController),

              const SizedBox(height: 10),

              // confirm password textfiel
              MyTextField(
                  hintText: "Confirmer le mot de passe",
                  obscureText: true,
                  controller: _confirmPwController),

              const SizedBox(height: 25),

              // register button
              MyButton(
                text: "S'inscrire",
                onTap: () async {
                  await registerUser();
                },
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginView(
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
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
