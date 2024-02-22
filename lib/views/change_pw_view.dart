import 'package:flutter/material.dart';
import 'package:flutter_app/viewModel/change_pw_view_model.dart';

class ChangePasswordView extends StatelessWidget {
  final ChangePasswordViewModel viewModel = ChangePasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: viewModel.oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Ancien mot de passe',
              ),
            ),
            TextField(
              controller: viewModel.newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
              ),
            ),
            TextField(
              controller: viewModel.confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmez le nouveau mot de passe',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                viewModel.changePassword(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 76, 61, 120),
              ),
              child: Text(
                'Changer le mot de passe',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
