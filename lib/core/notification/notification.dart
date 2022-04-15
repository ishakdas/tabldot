import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void notificationConfigure() async {
  late FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic("all");
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');
  _createNotificationChannel("channel_id_1", "channel_name", "description",
      "flutter_local_notifications_example_android_app_src_main_res_raw_slow_spring_board");
}

Future<void> _createNotificationChannel(String id, String name, String description, String sound) async {
  var androidNotificationChannel = AndroidNotificationChannel(
    id,
    name,
    sound: RawResourceAndroidNotificationSound(sound),
    playSound: true,
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound:
          'flutter_local_notifications_example_android_app_src_main_res_raw_slow_spring_board.caf'); //put your own sound text here

  late FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic("all");
  if (Platform.isIOS) {
    _requestIOSPermission();
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

_requestIOSPermission() {
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: false,
        badge: true,
        sound: true,
      );
}
