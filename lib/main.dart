// Importing necessary packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/authentification/auth.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

// Asynchronous main function
void main() async {
  // Ensuring Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase with default options for the current platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Starting the application with ChangeNotifierProvider
  runApp(ChangeNotifierProvider(
    create: (content) => ThemeProvider(),
    child: const MyApp(),
  ));
}

// Stateless widget for the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Returning MaterialApp widget
    return MaterialApp(
      // Setting application title
      title: 'Killer App',

      // Hiding debug banner
      debugShowCheckedModeBanner: false,

      // Setting home screen to AuthView
      home: AuthView(),

      // Setting application theme using ThemeProvider
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
