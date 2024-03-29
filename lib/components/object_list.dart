// This widget represents a list of objects fetched from Firestore and displayed in a ListView.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/boxdialog.dart';
import 'package:flutter_app/service/firestore.dart';
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
    _objectStream = FirestoreService()
        .getObjectStream(); // Initializing object stream from Firestore
  }

  // Method to open the dialog for adding a new object
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

  // Method to update text controllers with selected date and time
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
      print("Date format error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating action button for adding new objects
      floatingActionButton: FloatingActionButton(
        onPressed: openObjectBox,
        backgroundColor: Color.fromARGB(255, 76, 61, 120),
        child: Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      // Body containing a StreamBuilder for displaying the list of objects
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
                  return ObjectTile(
                      data: data, objId: objId); // Building each object tile
                } else {
                  return SizedBox(); // Placeholder for empty data
                }
              },
            );
          } else {
            return Center(
              child:
                  CircularProgressIndicator(), // Loading indicator while data is being fetched
            );
          }
        },
      ),
    );
  }
}

// Widget representing a single object tile
class ObjectTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String objId;

  const ObjectTile({required this.data, required this.objId});

  @override
  Widget build(BuildContext context) {
    String name = data['name'] ??
        'Nom non défini'; // Default value for object name if not defined
    String description = data['description'] ??
        'Description non définie'; // Default value for description
    Timestamp? timestamp = data['begindate']; // Timestamp for beginning date
    DateTime begindate = timestamp?.toDate() ??
        DateTime.now(); // Converting timestamp to DateTime
    Timestamp? timestamp2 = data['endate']; // Timestamp for end date
    DateTime endate = timestamp2?.toDate() ??
        DateTime.now(); // Converting timestamp to DateTime
    String formattedBeginDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(begindate); // Formatting begin date
    String formattedEndDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(endate); // Formatting end date

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary, width: 2),
      ),
      // Slidable widget for enabling swipe actions
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            // Slidable action for deleting object
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmation"),
                    content: Text(
                        "Voulez-vous vraiment supprimer cet objet ?"), // Confirmation message
                    actions: [
                      // Button for cancelling deletion
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
                      // Button for confirming deletion
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('objects')
                              .doc(objId)
                              .delete(); // Deleting object from Firestore
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
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: ListTile(
          // Details of the object displayed in ListTile
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
