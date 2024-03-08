// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_Objcard.dart';
import 'package:flutter_app/viewModel/home_view_model.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter_app/models/kill.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

final user = FirebaseAuth.instance.currentUser;

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
                      fontSize: 22,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                print(snapshot.error);

                return snapshot.data!.docs.isEmpty
                    ? Text('Aucune notification')
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot notificationSnapshot =
                              snapshot.data!.docs[index];

                          return ListTile(
                            title: Text(notificationSnapshot['message']),
                            subtitle: Text(
                                'À ${notificationSnapshot['timestamp'].toDate().toIso8601String()}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                confirmDeath(notificationSnapshot.id);
                                FirebaseFirestore.instance
                                    .collection('notifications')
                                    .doc(notificationSnapshot.id)
                                    .delete();
                              },
                              child: Text('Confirmer'),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SlideAction(
              innerColor: const Color.fromARGB(255, 72, 57, 117),
              outerColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              sliderButtonIcon: Icon(Icons.gps_fixed_rounded,
                  color: Color.fromARGB(255, 255, 255, 255)),
              text: '                Glisser pour confirmer votre kill !',
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
              sliderRotate: false,
              onSubmit: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Confirmer le kill"),
                      content: Text(
                          "Êtes-vous sûr de vouloir confirmer votre kill ?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Confirmer",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          onPressed: () {
                            validationKill();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Future<void> validationKill() async {
    String? targetUserId;

    QuerySnapshot killsSnapshot = await FirebaseFirestore.instance
        .collection('kills')
        .where('idKiller', isEqualTo: user?.uid)
        .limit(1)
        .get();

    if (killsSnapshot.docs.isNotEmpty) {
      targetUserId = killsSnapshot.docs[0]['idCible'];
    }

    if (targetUserId != null) {
      QuerySnapshot querySnapshot = await kills
          .where('idKiller', isEqualTo: user?.uid)
          .where('idCible', isEqualTo: targetUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs[0];
        await docSnapshot.reference.update({
          'etat': KillState.enValidation.name,
        });

        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': targetUserId,
          'message': 'Tu as été éliminé !',
          'timestamp': currentTimestamp,
          'confirmed': false,
        });
      }
    }
  }

  Future<void> confirmDeath(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({
      'confirmed': true,
    });
  }
}
