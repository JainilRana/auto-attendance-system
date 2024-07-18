import 'package:attendance_app/screens/homePageA.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/homePageS.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:attendance_app/screens/signUp.dart';
import 'package:attendance_app/utils/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attendance_app/firebase_options.dart';

Widget startScreen = const SignIn();
var db = FirebaseFirestore.instance;

getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(
      "Handling a background message: ${message.notification!.title.toString()}, ${message.notification!.body.toString()}");
}

Future<void> deleteDocumentAndSubcollections(String documentId) async {
  var docSnapshot = await db
      .collection('notifications')
      .doc(
        getCurrentUser().email.toString(),
      )
      .collection(
        formatter
            .format(
              DateTime.now().subtract(
                Duration(days: 1),
              ),
            )
            .toString(),
      )
      .get();
  for (var doc in docSnapshot.docs) {
    doc.reference.delete();
  }
  await db
      .collection('notifications')
      .doc(formatter
          .format(
            DateTime.now().subtract(
              Duration(days: 1),
            ),
          )
          .toString())
      .delete();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  mailType =
      await checkIdType(getCurrentUser() != null ? getCurrentUser().email : '');
  if (mailType == 'admin') {
    startScreen = const HomePageA();
  } else if (mailType == 'faculty') {
    await fetchStudentData();
    startScreen = const HomePageF();
  } else if (mailType == 'student') {
    startScreen = const HomePageS();
    try {
      await deleteDocumentAndSubcollections(
        formatter
            .format(
              DateTime.now().subtract(
                Duration(days: 1),
              ),
            )
            .toString(),
      ).then((value) {
        print(formatter
                .format(
                  DateTime.now().subtract(
                    Duration(days: 1),
                  ),
                )
                .toString() +
            ' deleted');
      });
    } catch (e) {
      print(e);
    }
  }
  if (!kIsWeb) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
  NotificationService notificationService = NotificationService();
  notificationService.setupFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
