import 'package:flutter/material.dart';
import 'package:flutter_app/components/object_list.dart';
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

            return ObjectList(
              objectsList: objectsList,
              data: {},
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
