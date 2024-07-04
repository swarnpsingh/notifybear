import 'package:flutter/material.dart';
import 'package:notifybear/screens/auth_screens/entry_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EntryScreen(),
    );
  }
}
