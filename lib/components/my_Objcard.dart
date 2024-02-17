import 'package:flutter/material.dart';

class ObjCard extends StatelessWidget {
  final Map<String, dynamic> objectData;

  ObjCard(this.objectData);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 72, 57, 117),
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0, 
                  horizontal: 16.0,
                ),
                child: Text(
                  "Nom de l'objet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  objectData['name'],
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0, 
                  horizontal: 16.0,
                ),
                child: Text(
                  "Description de l'objet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  objectData['description'],
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
