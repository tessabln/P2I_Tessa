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
                String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime);
                // Update text controller using the provided function
                updateTextController(
                    formattedDateTime, objectendateController.text);
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
                String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime);
                // Update text controller using the provided function
                updateTextController(
                    objectbegindateController.text, formattedDateTime);
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
  );
}
