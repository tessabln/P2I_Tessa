// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class KillList extends StatefulWidget {
  @override
  _KillListState createState() => _KillListState();
}

class _KillListState extends State<KillList> {
  late Stream<QuerySnapshot> _killStream;
  final FirestoreService firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    _killStream = FirebaseFirestore.instance
        .collection('kills')
        .snapshots();
  }

  // Liste des couleurs par famille
  final Map<String, Color> familyColors = {
    'Bleue': Color.fromARGB(255, 27, 47, 135),
    'Rouge': Color.fromARGB(255, 182, 31, 26),
    'Verte': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Jaune': Color.fromARGB(255, 215, 187, 65),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _killStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> killList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: killList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = killList[index];
                String killId = document.id;
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;

                if (data != null) {
                  return FutureBuilder(
                    future: _fetchUserData(data['idKiller'], data['idCible']),
                    builder: (context,
                        AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text('Error: ${userSnapshot.error}');
                      } else {
                        return KillTile(
                          data: data,
                          killId: killId,
                          userData: userSnapshot.data!,
                          familyColors: familyColors,
                        );
                      }
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firestore.createAndAddKills();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchUserData(
      String idKiller, String idCible) async {
    final killerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(idKiller)
        .get();
    final cibleDoc =
        await FirebaseFirestore.instance.collection('users').doc(idCible).get();
    final killerFam = await FirebaseFirestore.instance
        .collection('users')
        .doc(idKiller)
        .get();
    final cibleFam =
        await FirebaseFirestore.instance.collection('users').doc(idCible).get();

    return {
      'idKiller': killerDoc['lastname'] +
          ' ' +
          killerDoc['firstname'] +
          ' ' + 
          killerFam['family'],
      'idCible': cibleDoc['lastname'] +
          ' ' +
          cibleDoc['firstname'] +
          ' ' +
          cibleFam['family'],
    };
  }
}

class KillTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String killId;
  final Map<String, dynamic> userData;
  final Map<String, Color> familyColors;

  const KillTile(
      {required this.data,
      required this.killId,
      required this.userData,
      required this.familyColors});

  @override
  Widget build(BuildContext context) {
    String idKiller = userData['idKiller'] ?? 'idKiller non défini';
    String idCible = userData['idCible'] ?? 'idCible non défini';

    // Séparation du nom complet du tueur en utilisant l'espace comme séparateur
    List<String> idKillerParts = idKiller.split(' ');
    // Obtention de la famille à partir de la troisième partie
    String idKillerFamily = idKillerParts.length > 2 ? idKillerParts[2] : '';

    // Séparation du nom complet de la cible en utilisant l'espace comme séparateur
    List<String> idCibleParts = idCible.split(' ');
    // Obtention de la famille à partir de la troisième partie
    String idCibleFamily = idCibleParts.length > 2 ? idCibleParts[2] : '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary, width: 2),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmation"),
                    content: Text("Voulez-vous vraiment supprimer ce kill ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Annuler",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('kills')
                              .doc(killId)
                              .delete();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Supprimer",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                idKiller,
                style: TextStyle(
                  fontSize: 18,
                  color: familyColors[idKillerFamily],
                ),
              ),
              Text(
                'KILL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                idCible,
                style: TextStyle(
                  fontSize: 18,
                  color: familyColors[idCibleFamily],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
