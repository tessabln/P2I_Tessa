import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TargetsView extends StatefulWidget {
  @override
  State<TargetsView> createState() => _TargetsViewState();
}

class _TargetsViewState extends State<TargetsView> {
  final user = FirebaseAuth.instance.currentUser;
  var userList = FirebaseFirestore.instance.collection("users").snapshots();

  @override
  void initState() {
    super.initState();
  }


  final Map<String, Color> familyColors = {
    'Bleue': Color.fromARGB(255, 10, 28, 112),
    'Rouge': Color.fromARGB(255, 182, 31, 26),
    'Verte': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Jaune': Color.fromARGB(255, 215, 187, 65),
  };

  List<DocumentSnapshot> _userList = [];

  void updateUserList(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      final user = _userList.removeAt(oldIndex);
      _userList.insert(newIndex, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cibles"),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _userList = snapshot.data!.docs;
            return ReorderableListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                String lastname =
                    _userList[index]['lastname'] ?? 'Nom non défini';
                String firstname =
                    _userList[index]['firstname'] ?? 'Prénom non défini';
                String family = _userList[index]['family'] ?? '';

                Color backgroundColor =
                    familyColors[family] ?? Colors.transparent;

                return Container(
                  key: ValueKey(_userList[index].id),
                  color: backgroundColor,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$lastname $firstname',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                updateUserList(oldIndex,newIndex);
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
