// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, sort_child_properties_last, avoid_function_literals_in_foreach_calls, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;
  Future<DocumentSnapshot<Map<String, dynamic>>>? objectData;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
    Future<DocumentSnapshot<Map<String, dynamic>>>?
        objectData; //bonne ligne pour pas que ça soit tout faux
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getObjectData() async {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd-MM-yyyy à HH:mm:ss').format(now);
    print('Formatted Date: $formattedDate');

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("objects")
        .where('begindate', isLessThanOrEqualTo: formattedDate)
        .where('endate', isGreaterThanOrEqualTo: formattedDate)
        .get();
    print('Object Data: $objectData');

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userData,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || !snapshot.data!.exists) {
                return Text('Pas de donnée');
              } else {
                Map<String, dynamic> userData = snapshot.data!.data()!;
                return Text(
                  'Bonjour ${userData['firstname']},',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                );
              }
            },
          ),
        ),
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
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: objectData,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('Aucun objet trouvé');
                } else {
                  Map<String, dynamic> objectData = snapshot.data!.data()!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Nom de l'objet:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          objectData['name'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Description de l'objet:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          objectData['description'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 260),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SlideAction(
              elevation: 0,
              sliderButtonIcon: Icon(Icons.gps_fixed_rounded,
                  color: Theme.of(context).colorScheme.primary),
              text: '        Confirmez votre kill !',
              textStyle: const TextStyle(fontSize: 16),
              sliderRotate: false,
              onSubmit: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text(
                      "T'es sûr ?",
                    ));
                  },
                );
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}