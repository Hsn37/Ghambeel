import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<String> notifs_dataset = [
    	"Study now, khokha later",
	    "This too shall pass/fail.",
	    "It's not about perfect. It's about effort. - Jillian Michaels",
	    "Excellence is not a skill. It is an attitude.- Ralph Marston",
	    "You don't get what you wish for. You get what you work for. - Daniel Milstein",
	    "Do something now; your future self will thank you for later.",
	    "Don't try to be perfect. Just try to be better than you were yesterday.",
	    "Keep going. Everything you need will come to you at the perfect time.",
	    "Even the greatest were beginners. Don't be afraid to take that first step.",
	    "A little progress each day adds up to big results. - Satya Nani",
	    "It's not about having time. It's about making time.",
	    "Losers quit when they're tired. Winners quit when they've won.",
	    "Skill is only developed by hours and hours of work. - Usain Bolt",
	    "You will never always be motivated. You have to learn to be disciplined.",
	    "Self-discipline is the magic power that makes you virtually unstoppable. - Dan Kennedy",
	    "The way to get started is to quit talking and begin doing. - Walt Disney",
	    "Focus on doing the right things instead of a bunch of things. - Mike Krieger",
	    "Every expert was once a beginner. — Helen Hayes",
	    "Be so good they can't ignore you. — Steve Martin",
	    "Due tomorrow, do today.",
  ];

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
    print("Clicked on ${payload}");
  }

  static Future<void> show(String title, String content, NotifID id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('ghambeel1', 'ghambeelNotif',
            channelDescription: 'ghambeelNotif',
            importance: Importance.max,
            priority: Priority.max,
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
  alert,
}