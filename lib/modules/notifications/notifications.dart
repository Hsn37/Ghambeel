import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Notifications {

  static Future init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');
    
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, 
            iOS: null, 
            macOS: null);

    return flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static void onSelectNotification(String? payload) async {
    // Function where we handle the notification clicks. check the payload.
    print("Clicked on notification");
  }

  static Future<void> show(String title, String content, NotifID id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('ghambeel1', 'ghambeelNotif',
            channelDescription: 'ghambeelNotif',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker',
            playSound: true,
            styleInformation: BigTextStyleInformation(''),
            );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return await flutterLocalNotificationsPlugin.show(
        id.index, title, content, platformChannelSpecifics,
        payload: 'item x'
      );
  }
}

enum NotifID {
  motquote,
  deadline,
  backup,
}