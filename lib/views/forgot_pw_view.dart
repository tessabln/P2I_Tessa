import 'package:flutter/material.dart';
import 'package:flutter_app/viewModel/forgot_pw_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordViewModel viewModel = ForgotPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Entrez votre email et on vous enverra un lien de réinitialisation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: viewModel.emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              viewModel.passwordReset(context);
            },
            color: Color.fromARGB(255, 76, 61, 120),
            child: Text(
              'Réinitialiser mon mot de passe',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
