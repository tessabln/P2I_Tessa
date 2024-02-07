import 'package:flutter/material.dart';
import 'package:flutter_app/views/login_view.dart';
import 'package:flutter_app/views/player/register_view.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially, show login page
  bool showLoginView = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginView = !showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginView) {
      return LoginView(onTap: togglePages);
    } else {
      return RegisterView(onTap: togglePages);
    }
  }
}
