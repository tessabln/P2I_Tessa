import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/login_or_register.dart';
import 'package:flutter_app/views/home_view.dart';
import 'package:flutter_app/views/admin_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              if (snapshot.data!.email == "killer.appli@gmail.com") {
                // Navigate to a specific page based on the email
                return AdminView();
              } else {
                // Navigate to a default page if the email doesn't match any specific condition
                return HomeView();
              }
              
            }
            // user is NOT logged in
            else{
              return const LoginOrRegister();
            }
          },
      ),
    );
  }
}