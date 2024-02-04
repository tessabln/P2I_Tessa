// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, sort_child_properties_last, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  // DocumentReference? currentUserDocument;
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;

  // document IDs
  List<String> docIDs = [];

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  // get docIds
  // Future getDocId() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((snapshot) => snapshot.docs.forEach((document) {
  //             docIDs.add(document.reference.id);
  //           }));
  // }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    var document =
        FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    return document;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
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
          Expanded(
              //child: Text("BONJOU CLARINETTE"),
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userData,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                    'Loading...'); // Show loading indicator while waiting
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show error message if an error occurs
              } else {
                Map<String, dynamic> userData = snapshot.data!.data()!;
                return Text(
                    'Bonjour, ${userData['lastname']} ${userData['firstname']} de la famille ${userData['family']}'); // Show the first name when data is available
              }
            },
          )
              // child: FutureBuilder(
              //   future: getUserData(),
              //   builder: (context, snapshot) {
              //     return ListView.builder(
              //       itemCount: docIDs.length,
              //       itemBuilder: (context, index) {
              //         return ListTile(
              //           title: GetUserName(documentId: docIDs[index]),
              //         );
              //       },
              //     );
              //   },
              // ),
              ),
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
