import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:satis_app/screens/login_screen.dart';
import 'firebase_options.dart'; // Make sure this is correctly imported


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İkinci Nefes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginScreen(),
    );
  }
}
