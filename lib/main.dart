import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyqueue_app/screens/home_screen.dart'; // Ensure the correct path!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyQueue App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Ensure HomePage() exists
    );
  }
}
