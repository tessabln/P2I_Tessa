// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, sort_child_properties_last, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/views/admin/game_register_view.dart';
import 'package:flutter_app/views/admin/objects_view.dart';
import 'package:flutter_app/views/admin/targets_view.dart';
import 'package:flutter_app/views/admin/users_view.dart';

class AdminView extends StatefulWidget {
  final void Function()? onTap;

  const AdminView({super.key, required this.onTap});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return GameRegisterView();
                    },
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      "Créer le jeu",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            MyButton(
              text: "Gestion des objets",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ObjectsView();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MyButton(
              text: "Gestion des joueurs",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UsersView();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MyButton(
              text: "Gestion des cibles",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TargetsView();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MyButton(
              text: "Gestion des annonces",
              onTap: () {},
            ),
          ]),
        ),
      ),
    );
  }
}
