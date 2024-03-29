// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Stream<QuerySnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastname', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> usersList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = usersList[index];
              String userId = document.id;

              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;

              if (data != null) {
                return UserTile(data: data, userId: userId);
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
    );
  }
}

class UserTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String userId;

  const UserTile({required this.data, required this.userId});

  @override
  Widget build(BuildContext context) {
    String lastname = data['lastname'] ?? 'Nom non défini';
    String firstname = data['firstname'] ?? 'Prénom non défini';
    String status = data['status'] ?? 'Statut non défini';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary, width: 2),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirmation"),
                    content: Text(
                        "Voulez-vous vraiment supprimer cet utilisateur ?"),
                    actions: [
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
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .delete();
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
              }),
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Column(
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
              Expanded(
                child: Text(
                  'Statut: $status',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
