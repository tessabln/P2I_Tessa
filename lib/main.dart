import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/auth.dart';
import 'package:flutter_app/auth/login_or_register.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/theme/theme_provider.dart';
import 'package:flutter_app/views/home.dart';
import 'package:flutter_app/views/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (content) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Killer App',
      debugShowCheckedModeBanner: false,
      home: AuthView(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
