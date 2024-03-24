// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unnecessary_null_comparison, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_Objcard.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:flutter_app/viewModel/home_view_model.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

final user = FirebaseAuth.instance.currentUser;
final FirestoreService firestore = FirestoreService();

DateTime getToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

final CollectionReference kills =
    FirebaseFirestore.instance.collection('kills');

DateTime now = DateTime.now();
Timestamp currentTimestamp = Timestamp.fromDate(now);

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = HomeViewModel();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final snapshot = await viewModel.getUserData();
    if (snapshot != null && snapshot.exists) {
      setState(() {
        userData = snapshot.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = getToday();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: viewModel.getUserData(),
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
                  'Bonjour ${userData['firstname']} !',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 28,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                );
              }
            },
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 60,
            height: 60,
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
              future: viewModel.getObjectData(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('Aucun objet trouvé');
                } else {
                  Map<String, dynamic> objectData = snapshot.data!.data()!;
                  final Timestamp? beginDateTimestamp = objectData["begindate"];
                  if (beginDateTimestamp != null &&
                      beginDateTimestamp.toDate().isBefore(now)) {
                    return ObjCard(objectData);
                  } else {
                    return Text('Aucun objet trouvé');
                  }
                }
              },
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.inversePrimary),
          StreamBuilder(
            stream: viewModel.getPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;
              final todayPosts = posts.where((post) {
                Timestamp timestamp = post['TimeStamp'];
                DateTime postDate = timestamp.toDate();
                DateTime postDateWithoutTime =
                    DateTime(postDate.year, postDate.month, postDate.day);
                return postDateWithoutTime.isAtSameMomentAs(today);
              }).toList();

              if (todayPosts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "Aucune annonce ce jour",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: todayPosts.length,
                  itemBuilder: (context, index) {
                    // get each indiv post
                    final post = todayPosts[index];

                    // get data from each post
                    String message = post['PostMessage'];

                    // return as a list tile
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: ListTile(
                        title: Text(
                          'Annonce du jour : $message',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: userData != null && userData?['status'] != 'mort'
                ? SlideAction()
                : Container(
                    child: Center(
                      child: Text(
                        'Tu es mort \u{1F480}',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
