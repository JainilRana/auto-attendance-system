import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getDeviceToken() async {
    // Get the device token
    String deviceToken = await firebaseMessaging.getToken() ?? '';
    return deviceToken;
  }
}