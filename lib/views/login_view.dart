import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/views/forgot_pw_view.dart';
import 'package:flutter_app/views/user/register_view.dart';
import 'package:flutter_app/auth/userAuth.dart';

class LoginView extends StatefulWidget {
  final void Function()? onTap;
  const LoginView({Key? key, required this.onTap}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Container(
                width: 181,
                height: 184,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              // app name
              Text(
                "T H E  K I L L E R",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 80),

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

              // forgot password
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordView();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                            color:
                               Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              GestureDetector(
                onTap: () => AuthService.logIn(
                    emailController.text, passwordController.text, context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 76, 61, 120),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(25),
                    child: Center(
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous n'avez pas de compte ?",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterView(
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      " Inscrivez-vous ici",
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
