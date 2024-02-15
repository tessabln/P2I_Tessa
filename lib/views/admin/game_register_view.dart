// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/components/functions.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:intl/intl.dart';

class GameRegisterView extends StatefulWidget {
  const GameRegisterView({Key? key}) : super(key: key);

  @override
  State<GameRegisterView> createState() => _GameRegisterViewState();
}

class _GameRegisterViewState extends State<GameRegisterView> {
  // text controllers
  final TextEditingController gamenameController = TextEditingController();
  final TextEditingController begindateController = TextEditingController();
  final TextEditingController endateController = TextEditingController();

  @override
  void dispose() {
    gamenameController.dispose();
    begindateController.dispose();
    endateController.dispose();
    super.dispose();
  }

  //register method
  Future registerGame() async {
    try {
      final DateTime begindate =
          DateFormat('yyyy-MM-dd').parse(begindateController.text.trim());
      final DateTime endate =
          DateFormat('yyyy-MM-dd').parse(endateController.text.trim());

      // add game details
      FirestoreService().addGameDetails(
        gamenameController.text.trim(),
        begindate,
        endate,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // display error message to user
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

              const SizedBox(height: 60),

              // gamename textfield
              MyTextField(
                  hintText: "Nom",
                  obscureText: false,
                  controller: gamenameController),

              const SizedBox(height: 10),

              // begindate textfield
              TextField(
                  controller: begindateController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Date de début"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);

                      setState(() {
                        begindateController.text = formattedDate;
                      });
                    } else {
                      print("La date n'est pas sélectionnée");
                    }
                  }),

              const SizedBox(height: 10),

              // endate textfield
              TextField(
                  controller: endateController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Date de fin"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        endateController.text = formattedDate;
                      });
                    } else {
                      print("La date n'est pas sélectionnée");
                    }
                  }),

              const SizedBox(height: 50),

              // register button
              MyButton(
                text: "Valider",
                onTap: registerGame,
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
