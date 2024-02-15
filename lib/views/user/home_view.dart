// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_Objcard.dart';
import 'package:flutter_app/services/firestore.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService firestore = FirestoreService();
  Future<DocumentSnapshot<Map<String, dynamic>>>? userData;
  Future<DocumentSnapshot<Map<String, dynamic>>>? objectData;
  Stream<QuerySnapshot<Map<String, dynamic>>>? messagesStream;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
    objectData = getObjectData();
    messagesStream =
        FirebaseFirestore.instance.collection('messages').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getObjectData() async {
    DateTime now = DateTime.now();

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("objects")
        .where('endate', isGreaterThanOrEqualTo: now)
        .orderBy('endate', descending: false)
        .get();

    return snapshot.docs.first;
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
                      color: Theme.of(context).colorScheme.primary),
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
          const SizedBox(height: 30),
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
                  return ObjCard(objectData);
                }
              },
            ),
          ),
          Divider(),
          StreamBuilder(
            stream: firestore.getPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty) {
                return Center(
                  child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Aucune annonce ce jour",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each indiv post
                    final post = posts[index];

                    // get data from each post
                    String message = post['PostMessage'];
                    Timestamp timestamp = post['TimeStamp'];

                    // return as a list tile
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: ListTile(
                        title: Text('Annonce du jour : $message',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SlideAction(
              elevation: 0,
              sliderButtonIcon: Icon(Icons.gps_fixed_rounded,
                  color: Theme.of(context).colorScheme.secondary),
              text: '         Confirmez votre kill !',
              textStyle: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
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
