import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageF(),
    );
  }
}
