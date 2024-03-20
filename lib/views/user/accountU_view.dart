// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/account_components.dart';
import 'package:flutter_app/components/my_button.dart';
import 'package:flutter_app/components/functions.dart';
import 'package:flutter_app/service/firestore.dart';
import 'package:flutter_app/views/change_pw_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/theme/theme_provider.dart';

class AccountView extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  final String notifId;
  final FirestoreService firestore = FirestoreService();

  AccountView({required this.notifId});
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          const Text("Dark mode"),
          CupertinoSwitch(
            value:
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            activeColor: Color.fromARGB(255, 76, 61, 120),
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(
                Icons.person,
                size: 72,
              ),
              const SizedBox(height: 20),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('userId', isEqualTo: user?.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Text('Aucune notification');
                    }

                    DocumentSnapshot notificationSnapshot =
                        snapshot.data!.docs[0];

                    return ListTile(
                      title: Text(notificationSnapshot['message']),
                      subtitle: Text(
                          'À ${notificationSnapshot['timestamp'].toDate().toIso8601String()}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await firestore
                                  .confirmDeath(notificationSnapshot.id);
                              await firestore.death(currentUser.uid);
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .doc(notificationSnapshot.id)
                                  .delete();
                            },
                            child: Text(
                              'Confirmer',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          SizedBox(width: 2),
                          ElevatedButton(
                            onPressed: () async {
                              await firestore
                                  .rejectDeath(notificationSnapshot.id);
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .doc(notificationSnapshot.id)
                                  .delete();
                            },
                            child: Text(
                              'Refuser',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 90),
              MyButton(
                text: "Changer mon mot de passe",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangePasswordView();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Supprimer mon compte",
                onTap: () => AccountViewComponents.confirmDeleteUser(
                    context, currentUser.uid),
              ),
              const SizedBox(height: 10),
              MyButton(
                text: " Voir ma cible",
                onTap: () {
                  AccountViewComponents.showTargetDialog(
                      context, currentUser.uid);
                },
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
                child: SizedBox(
                  width: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 76, 61, 120),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Se déconnecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
