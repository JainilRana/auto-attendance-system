import 'package:attendance_app/screens/homePageA.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:attendance_app/screens/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attendance_app/firebase_options.dart';

Widget startScreen = SignIn();
String adminId = 'admin@charusat.edu.in';
String adminPass = 'admin123';
var db = FirebaseFirestore.instance;
getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    // check ID type
    if (user != null && user.email == adminId) {
      startScreen = HomePageA();
    } else if (mailType == 'faculty') {
      startScreen = HomePageF();
    } // else if (mailType == 'student') { return student homepage }
    else {
      startScreen = SignIn();
    }
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startScreen,
    );
  }
}
