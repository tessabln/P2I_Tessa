// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Stream<QuerySnapshot> _postStream;
  final FirestoreService firestore = FirestoreService();
  final TextEditingController newPostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postStream = firestore.getPostsStream();
  }

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      firestore.addPost(message);
      newPostController.clear();
    }
  }

  @override
  void dispose() {
    newPostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newPostController,
                    decoration: InputDecoration(
                      hintText: "Exprime toi..",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: postMessage,
                  child: Text('Post'),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _postStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> postList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = postList[index];
                      String postId = document.id;
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      if (data != null) {
                        return PostTile(data: data, postId: postId);
                      } else {
                        return Text(
                            "Pas de message.. Partager quelque chose !");
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
          ),
        ],
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String postId;

  const PostTile({required this.data, required this.postId});

  @override
  Widget build(BuildContext context) {
    String message = data['PostMessage'] ?? 'Message non défini';
    Timestamp? timestamp = data['date'];
    DateTime date = timestamp?.toDate() ?? DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
                              .collection('posts')
                              .doc(postId)
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
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Message : $message',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Date : $formattedDate',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
