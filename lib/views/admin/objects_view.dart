// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ObjectsView extends StatefulWidget {
  @override
  State<ObjectsView> createState() => _ObjectsViewState();
}

class _ObjectsViewState extends State<ObjectsView> {
  final TextEditingController objectnameController = TextEditingController();
  final TextEditingController objectdescriptionController =
      TextEditingController();
  final TextEditingController objectbegindateController =
      TextEditingController();
  final TextEditingController objectendateController = TextEditingController();

  @override
  void dispose() {
    objectnameController.dispose();
    objectdescriptionController.dispose();
    objectbegindateController.dispose();
    objectendateController.dispose();
    super.dispose();
  }

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
              controller: objectbegindateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Date de début",
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
                      objectbegindateController.text = formattedDateTime;
                    });
                  }
                }
              },
            ),
            TextField(
              controller: objectendateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Date de fin",
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
                      objectendateController.text = formattedDateTime;
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
              final DateTime objectbegindate = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(objectbegindateController.text.trim());

              final DateTime objectendate = DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse(objectendateController.text.trim());

              // Ajout d'objets dans Firestore
              FirebaseFirestore.instance.collection('objects').add({
                'name': objectnameController.text,
                'description': objectdescriptionController.text,
                'begindate': objectbegindate,
                'endate': objectendate,
              });

              objectnameController.clear();
              objectdescriptionController.clear();
              objectbegindateController.clear();
              objectendateController.clear();

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
      appBar: AppBar(
        title: Text("Objets"),
        backgroundColor: Theme.of(context).colorScheme.background,
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
      floatingActionButton: FloatingActionButton(
        onPressed: openObjectBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('objects')
            .orderBy('begindate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> objectsList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: objectsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = objectsList[index];
                //String userId= document.id;

                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;

                if (data != null) {
                  String objname = data['name'] ?? 'Nom non défini';
                  String objdescrip =
                      data['description'] ?? 'Description non défini';
                  Timestamp? timestamp = data['begindate'];
                  DateTime objbegindate = timestamp?.toDate() ?? DateTime.now();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(objbegindate);
                  Timestamp? timestamp2 = data['endate'];
                  DateTime objendate = timestamp2?.toDate() ?? DateTime.now();
                  String formattedDate2 =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(objendate);

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$objname',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Description: $objdescrip',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Date de début: $formattedDate',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 14),
                          ),
                          Text(
                            'Date de fin: $formattedDate2',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
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
    );
  }
}
