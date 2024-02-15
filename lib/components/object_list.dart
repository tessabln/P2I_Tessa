// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/boxdialog.dart';
import 'package:flutter_app/services/firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ObjectList extends StatefulWidget {
  @override
  _ObjectListState createState() => _ObjectListState();
}

class _ObjectListState extends State<ObjectList> {
  late Stream<QuerySnapshot> _objectStream;
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

  @override
  void initState() {
    super.initState();
    _objectStream = FirestoreService().getObjectStream();
  }

  void openObjectBox() {
    showDialog(
      context: context,
      builder: (context) => addObjectDialog(
        context,
        objectbegindateController,
        objectendateController,
        updateTextController,
      ),
    );
  }

  void updateTextController(String begindate, String endate) {
    try {
      DateTime parsedBeginDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(begindate);
      DateTime parsedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endate);

      setState(() {
        objectbegindateController.text =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedBeginDate);
        objectendateController.text =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedEndDate);
      });
    } catch (e) {
      print("Erreur de format de date: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openObjectBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _objectStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> objectList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: objectList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = objectList[index];
                String objId = document.id;
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;

                if (data != null) {
                  return ObjectTile(data: data, objId: objId);
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

class ObjectTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String objId;

  const ObjectTile({required this.data, required this.objId});

  @override
  Widget build(BuildContext context) {
    String name = data['name'] ?? 'Nom non défini';
    String description = data['description'] ?? 'Description non définie';
    Timestamp? timestamp = data['begindate'];
    DateTime begindate = timestamp?.toDate() ?? DateTime.now();
    Timestamp? timestamp2 = data['endate'];
    DateTime endate = timestamp2?.toDate() ?? DateTime.now();
    String formattedBeginDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(begindate);
    String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endate);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmation"),
                    content: Text("Voulez-vous vraiment supprimer cet objet ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('objects')
                              .doc(objId)
                              .delete();
                          Navigator.pop(context);
                        },
                        child: Text("Supprimer"),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
            ),
          ],
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nom: $name',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description: $description',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'Date de début: $formattedBeginDate',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
              Text(
                'Date de fin: $formattedEndDate',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
