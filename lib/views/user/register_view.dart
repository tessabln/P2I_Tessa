import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/viewModel/register_view_model.dart';
import 'package:flutter_app/views/login_view.dart';

class RegisterView extends StatelessWidget {
  final void Function()? onTap;

  RegisterView({Key? key, required this.onTap}) : super(key: key);

  final RegisterViewModel viewModel = RegisterViewModel();

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
                width: 91,
                height: 94,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // userlastname textfield
              MyTextField(
                hintText: "Nom",
                obscureText: false,
                controller: viewModel.userlastnameController,
              ),

              const SizedBox(height: 10),

              // userfirstname textfield
              MyTextField(
                hintText: "Prénom",
                obscureText: false,
                controller: viewModel.userfirstnameController,
              ),

              const SizedBox(height: 10),

              // userfamily textfield
              MyTextField(
                hintText: "Famille (Bleue, Verte, etc.)",
                obscureText: false,
                controller: viewModel.userfamilyController,
              ),

              const SizedBox(height: 10),

              // targetcode textfield
              MyTextField(
                hintText: "Code (à chiffres)",
                obscureText: true,
                controller: viewModel.targetcodeController,
              ),

              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: viewModel.emailController,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                hintText: "Mot de passe",
                obscureText: true,
                controller: viewModel.passwordController,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                hintText: "Confirmer le mot de passe",
                obscureText: true,
                controller: viewModel.confirmPwController,
              ),

              const SizedBox(height: 25),

              // register button
              GestureDetector(
                onTap: () async {
                  await viewModel.registerUser(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 76, 61, 120),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Center(
                    child: Text(
                      "S'inscrire",
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
                    "Vous avez déjà un compte ?",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color),
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
