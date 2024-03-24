// ignore_for_file: file_names
// This widget represents the user's target view. It displays details about the user's current target.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTargetView extends StatelessWidget {
  final Map<String, dynamic> data; // Data related to the target
  final String? userId; // ID of the user

  // Map containing family colors
  final Map<String, Color> familyColors = {
    'Blue': Color.fromARGB(255, 32, 67, 223),
    'Red': Color.fromARGB(255, 182, 31, 26),
    'Green': Color.fromARGB(255, 43, 144, 63),
    'Orange': Color.fromARGB(255, 247, 118, 6),
    'Yellow': Color.fromARGB(255, 215, 187, 65),
  };

  UserTargetView({required this.data, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('kills')
                  .where('idKiller', isEqualTo: user!.uid)
                  .where('state', isEqualTo: 'inProgress')
                  .limit(1)
                  .get(),
              builder: (context, killsSnapshot) {
                if (killsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Loading indicator while fetching data
                } else if (killsSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${killsSnapshot.error}')); // Display error message if any
                } else {
                  if (killsSnapshot.data!.docs.isNotEmpty) {
                    String? targetId = killsSnapshot.data!.docs[0]
                        ['targetId']; // ID of the target

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(targetId)
                          .get(),
                      builder: (context, targetSnapshot) {
                        if (targetSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Loading indicator while fetching target data
                        } else if (targetSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error: ${targetSnapshot.error}')); // Display error message if any
                        } else {
                          if (targetSnapshot.hasData &&
                              targetSnapshot.data!.exists) {
                            String firstname = targetSnapshot
                                .data!['firstname']; // First name of the target
                            String lastname = targetSnapshot
                                .data!['lastname']; // Last name of the target
                            String family = targetSnapshot.data!['family'] ??
                                ''; // Family of the target
                            Color textColor = familyColors[family] ??
                                Colors
                                    .transparent; // Text color based on family

                            return Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: textColor,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          'Your target is: \n', // Text indicating the target
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary),
                                    ),
                                    TextSpan(
                                      text:
                                          '$firstname $lastname', // Displaying target's full name
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                                child: Text(
                                    'No target found')); // Displayed when no target is found
                          }
                        }
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                            "You're dead. You don't have a target anymore.")); // Displayed when user is dead
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
