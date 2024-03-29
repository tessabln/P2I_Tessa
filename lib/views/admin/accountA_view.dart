// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/functions.dart';
import 'package:flutter_app/views/change_pw_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/theme/theme_provider.dart';

class AccountViewA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          const Text("Dark mode"),
          CupertinoSwitch(
            value:
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            activeColor: Color.fromARGB(255, 76, 61, 120),
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Icon(
                Icons.person,
                size: 72,
              ),
              const SizedBox(height: 120),
              MyButton(
                text: "Changer mon mot de passe",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangePasswordView();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 120),
              GestureDetector(
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
                child: SizedBox(
                  width: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 76, 61, 120),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Se déconnecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
