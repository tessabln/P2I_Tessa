import 'package:flutter/material.dart';
import 'package:flutter_app/models/object.dart';
import 'package:flutter_app/helper/boxdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      builder: (context) => addObjectDialog(
        context,
        objectbegindateController,
        objectendateController,
        updateTextController,
      ),
    );
  }

  // Function to update text controllers
  void updateTextController(String begindate, String endate) {
    DateTime parsedBeginDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(begindate);
    DateTime parsedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endate);

    setState(() {
      objectbegindateController.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedBeginDate);
      objectendateController.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedEndDate);
    });
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
            List<Object> objectsList = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Object.fromFirestore(data);
            }).toList();

            return ListView.builder(
              itemCount: objectsList.length,
              itemBuilder: (context, index) {
                Object object = objectsList[index];

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
                          object.name,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: ${object.description}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Date de début: ${object.formattedBeginDate}',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        Text(
                          'Date de fin: ${object.formattedEndDate}',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
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
