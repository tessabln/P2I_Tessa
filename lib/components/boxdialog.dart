// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This function creates an AlertDialog widget for adding an object with various details.
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
        // Text field for entering the name of the object
        TextField(
          controller: objectnameController,
          decoration: InputDecoration(
            labelText: "Nom",
          ),
        ),
        // Text field for entering the description of the object
        TextField(
          controller: objectdescriptionController,
          decoration: InputDecoration(
            labelText: "Description",
          ),
        ),
        // Text field for selecting the beginning date of the object
        TextField(
          controller: objectbegindateController,
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: "Date de début",
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDateTime = await _selectDateTime(context);
            if (pickedDateTime != null) {
              // Updating the text controller with the selected date
              updateTextController(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime),
                objectendateController.text,
              );
              objectbegindateController.text =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDateTime);
            }
          },
        ),
        // Text field for selecting the end date of the object
        TextField(
          controller: objectendateController,
          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: "Date de fin",
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDateTime = await _selectDateTime(context);
            if (pickedDateTime != null) {
              // Updating the text controller with the selected date
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
      // Button for adding the object
      ElevatedButton(
        onPressed: () {
          // Parsing date and time strings to DateTime objects
          final DateTime objectbegindate = DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(objectbegindateController.text.trim());

          final DateTime objectendate = DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(objectendateController.text.trim());

          // Adding object details to Firestore
          FirebaseFirestore.instance.collection('objects').add({
            'name': objectnameController.text,
            'description': objectdescriptionController.text,
            'begindate': objectbegindate,
            'endate': objectendate,
          });

          // Clearing text controllers after adding object
          objectnameController.clear();
          objectdescriptionController.clear();
          objectbegindateController.clear();
          objectendateController.clear();

          // Closing the dialog
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(
              255, 76, 61, 120), // Custom button background color
        ),
        child: Text(
          "Ajouter", // Button text for adding object
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(
                  255, 255, 255, 255)), // Custom button text style
        ),
      )
    ],
  );
}

// Function to select date and time from a dialog
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
      // Combining picked date and time into a DateTime object
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
