import 'package:flutter/material.dart';

class LeaderboardView extends StatelessWidget {
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
            _buildCircle(Color.fromARGB(255, 255, 111, 0), "5"),
            _buildCircle(Color.fromARGB(255, 255, 208, 0), "10"),
            _buildCircle(Color.fromARGB(255, 11, 14, 204), "40"),
            _buildCircle(Color.fromARGB(255, 6, 142, 11), "20"),
            _buildCircle(Color.fromARGB(255, 146, 9, 9), "25"),
          ],
        ),
        const SizedBox(height: 100),
        Text(
          "Nombre de survivants",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircle(Color.fromARGB(255, 255, 111, 0), "5"),
            _buildCircle(Color.fromARGB(255, 255, 208, 0), "10"),
            _buildCircle(Color.fromARGB(255, 11, 14, 204), "40"),
            _buildCircle(Color.fromARGB(255, 6, 142, 11), "20"),
            _buildCircle(Color.fromARGB(255, 146, 9, 9), "25"),
          ],
        ),
        const SizedBox(height: 100),
        Text(
          "Top kill",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircle(Color.fromARGB(255, 11, 14, 204), "5"),
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
