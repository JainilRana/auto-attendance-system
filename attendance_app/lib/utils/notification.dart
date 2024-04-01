import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      print('Got a message whilst in the foreground!');
      print(
          'Message data: ${message.notification!.title.toString()}, ${message.notification!.body.toString()}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background messages
      log('A new onMessageOpenedApp event was published!');
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.notification!.title.toString()}, ${message.notification!.body.toString()}');
    });
  }

  Future<String> getDeviceToken() async {
    // Get the device token
    String deviceToken = await firebaseMessaging.getToken() ?? '';
    return deviceToken;
  }
}
