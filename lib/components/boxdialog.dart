// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget addObjectDialog(
  BuildContext context,
  TextEditingController objectbegindateController,
  TextEditingController objectendateController,
  Function(String, String) updateTextController,
) {
  final TextEditingController objectnameController = TextEditingController();
  final TextEditingController objectdescriptionController =
      TextEditingController();

  return AlertDialog(
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
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: "Date de début",
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDateTime = await _selectDateTime(context);
            if (pickedDateTime != null) {
              updateTextController(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime),
                objectendateController.text,
              );
              objectbegindateController.text =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime);
            }
          },
        ),
        TextField(
          controller: objectendateController,
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: "Date de fin",
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDateTime = await _selectDateTime(context);
            if (pickedDateTime != null) {
              updateTextController(
                objectbegindateController.text,
                DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime),
              );
              objectendateController.text =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime);
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 76, 61, 120), 
        ),
        child: Text("Ajouter",
        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),),
      )
    ],
  );
}

Future<DateTime?> _selectDateTime(BuildContext context) async {
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
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }
  return null;
}
