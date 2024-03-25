// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/service/firestore.dart';

class LeaderboardView extends StatelessWidget {
  // Initializing FirestoreService and lists for families and their colors
  final FirestoreService firestore = FirestoreService();
  final List<String> families = ['Orange', 'Jaune', 'Bleue', 'Verte', 'Rouge'];
  final List<Color> colors = [
    Color.fromARGB(255, 255, 111, 0),
    Color.fromARGB(255, 255, 208, 0),
    Color.fromARGB(255, 11, 14, 204),
    Color.fromARGB(255, 6, 142, 11),
    Color.fromARGB(255, 146, 9, 9),
  ];

  // Constructor for LeaderboardView
  LeaderboardView();

  // Private method to retrieve data from Firestore based on family and data type
  Future<int> _getData(String family, String dataType) async {
    switch (dataType) {
      case 'kills':
        return await firestore.getFamilyKills(family);
      case 'survivants':
        return await firestore.getLifeCountForFamily(family);
      case 'bestKiller':
        return await firestore.getBestKillerForFamily(family);
      default:
        throw ArgumentError('Invalid data type');
    }
  }

  // Overriding the build method to return the leaderboard UI
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: firestore.getUserKills(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, userKillsSnapshot) {
        if (userKillsSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (userKillsSnapshot.hasError) {
          return Text('Erreur: ${userKillsSnapshot.error}');
        } else {
          final userKills = userKillsSnapshot.data ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 76, 61, 120), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Mes Kills: $userKills',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 50),
              _buildSection('Nombre de kills', 'kills', userKills),
              SizedBox(height: 100),
              _buildSection('Nombre de survivants', 'survivants', userKills),
              SizedBox(height: 100),
              _buildSection('Meilleur killer', 'bestKiller', userKills),
            ],
          );
        }
      },
    );
  }

  // Method to build a circle widget with a given color and text
  Widget _buildCircle(Color color, String text) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: color,
              shape: CircleBorder(),
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build a section of the leaderboard with a given title and data type
  Widget _buildSection(String title, String dataType, int userKills) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          children: families.map((family) {
            int index = families.indexOf(family);
            return Expanded(
              child: FutureBuilder<int>(
                future: _getData(family, dataType),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                        colors[index], snapshot.data.toString());
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
