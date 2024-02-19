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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 20, 25.0, 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // logo
                Container(
                  width: 101,
                  height: 104,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

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

                const SizedBox(height: 10),

                // register button
                GestureDetector(
                  onTap: () async {
                    await viewModel.registerUser(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 76, 61, 120),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(12),
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

                const SizedBox(height: 50),

                // don't have an account? Register here
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color.fromARGB(255, 76, 61, 120),
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 76, 61, 120),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
