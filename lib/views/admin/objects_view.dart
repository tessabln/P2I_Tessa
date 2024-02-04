// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/firestore.dart';
import 'package:intl/intl.dart';

class ObjectsView extends StatefulWidget {
  @override
  State<ObjectsView> createState() => _ObjectsViewState();
}

class _ObjectsViewState extends State<ObjectsView> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController objectnameController = TextEditingController();
  final TextEditingController objectdescriptionController =
      TextEditingController();
  final TextEditingController objectdateController = TextEditingController();

  @override
  void dispose() {
    objectnameController.dispose();
    objectdescriptionController.dispose();
    objectdateController.dispose();
    super.dispose();
  }

  // Fonction pour afficher la boîte de dialogue
  void openObjectBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: objectnameController,
              decoration: InputDecoration(
                labelText: "Nom",
              ),
            ),
            TextField(
              controller: objectdescriptionController,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            TextField(
              controller: objectdateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Date",
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    DateTime selectedDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(selectedDateTime);
                    setState(() {
                      objectdateController.text = formattedDateTime;
                    });
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final DateTime objectdate = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(objectdateController.text.trim());

              firestoreService.addObject(
                objectnameController.text,
                objectdescriptionController.text,
                objectdate,
              );

              objectnameController.clear();
              objectdescriptionController.clear();
              objectdateController.clear();

              Navigator.pop(context);
            },
            child: Text("Ajouter"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Objets")),
      floatingActionButton: FloatingActionButton(
        onPressed: openObjectBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getObjectsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List objectsList = snapshot.data!.docs;

            // Display as a list
            return ListView.builder(
              itemCount: objectsList.length,
              itemBuilder: (context, index) {
                // Get each indiv doc
                DocumentSnapshot document = objectsList[index];
                String docID = document.id;

                // Get obj from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String objname = data['name'] ?? 'Nom non défini';
                String objdescrip =
                    data['description'] ?? 'Description non défini';
                Timestamp timestamp = data['date'];
                DateTime objdate = timestamp.toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(objdate);

                // Display as a list tile
                return ListTile(
                  title: Text('Nom: $objname'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: $objdescrip'),
                      Text(
                        'Date: $formattedDate',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            // Return a loading indicator or an empty widget when snapshot.hasData is false
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
