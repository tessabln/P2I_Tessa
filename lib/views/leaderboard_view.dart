import 'package:flutter/material.dart';
import 'package:flutter_app/service/firestore.dart';

class LeaderboardView extends StatelessWidget {
  final FirestoreService firestore = FirestoreService();

  LeaderboardView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Nombre de kills",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getFamilyKills('Orange'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 111, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getFamilyKills('Jaune'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 208, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getFamilyKills('Bleue'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 11, 14, 204),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getFamilyKills('Verte'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 6, 142, 11),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getFamilyKills('Rouge'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 146, 9, 9),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 100),
        Text(
          "Nombre de survivants",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getLifeCountForFamily('Orange'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 111, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getLifeCountForFamily('Jaune'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 208, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getLifeCountForFamily('Bleue'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 11, 14, 204),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getLifeCountForFamily('Verte'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 6, 142, 11),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getLifeCountForFamily('Rouge'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 146, 9, 9),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 100),
        Text(
          "Meilleur killer",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getBestKillerForFamily('Orange'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 111, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getBestKillerForFamily('Jaune'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 255, 208, 0),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getBestKillerForFamily('Bleue'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 36, 39, 228),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getBestKillerForFamily('Verte'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 6, 142, 11),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<int>(
                future: firestore.getBestKillerForFamily('Rouge'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    return _buildCircle(
                      Color.fromARGB(255, 146, 9, 9),
                      snapshot.data.toString(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

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
}
