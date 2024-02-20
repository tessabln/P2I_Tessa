import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_Objcard.dart';
import 'package:flutter_app/viewModel/home_view_model.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}
DateTime getToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day); // Réinitialise l'heure à 00:00:00
}

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
                  return ObjCard(objectData);
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

              if (snapshot.data == null || posts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "Aucune annonce ce jour",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }

              // Filtrer les annonces pour ne récupérer que celles avec la date d'aujourd'hui
              final todayPosts = posts.where((post) {
                Timestamp timestamp = post['TimeStamp'];
                DateTime postDate = timestamp.toDate();
                DateTime postDateWithoutTime = DateTime(
                    postDate.year,
                    postDate.month,
                    postDate.day); // Réinitialise l'heure à 00:00:00
                return postDateWithoutTime.isAtSameMomentAs(today);
              }).toList();

              if (todayPosts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "Aucune annonce ce jour",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
                    Timestamp timestamp = post['TimeStamp'];

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
              outerColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              sliderButtonIcon: Icon(Icons.gps_fixed_rounded,
                  color: Theme.of(context).colorScheme.primary),
              text: '                Glisser pour confirmer votre kill !',
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
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
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
