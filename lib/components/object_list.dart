import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/object.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ObjectList extends StatelessWidget {
  final List<Object> objectsList;
  final Map<String, dynamic> data;


  const ObjectList(
      {required this.data, required this.objectsList});

  @override
  Widget build(BuildContext context) {
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
                        content:
                            Text("Voulez-vous vraiment supprimer cet objet ?"),
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
                                  .doc()
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
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  Text(
                    'Date de fin: ${object.formattedEndDate}',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
