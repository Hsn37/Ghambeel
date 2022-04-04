import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../theme.dart';

final today = DateTime.now();
final firstDay = DateTime(today.year, today.month - 10, today.day);
final lastDay = DateTime(today.year, today.month + 10, today.day);

class Mysql {
  static String host = '74.207.234.113',
      user = 'esseee',
      password = 'essee1234',
      db = 'mydb';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }
}

String getNowDateTime() {
  return DateTime.now().toString().split(".")[0];
}

final appBarTitles = ["Calendar", "To-do List", "Timers", "Statistics"];

Future youSure(title, content , context) {
  return showDialog(context: context, builder: (context){
    return AlertDialog(
        title: Text(title, style: TextStyle(color: primaryText[darkMode])),
        backgroundColor: bg[darkMode],
        content: Text(content, style: TextStyle(color: primaryText[darkMode])),

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(true);
            },
            child:Text("Yes", style: TextStyle(color: primaryText[darkMode])),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(false);
            },
            child:const Text("No", style: TextStyle(color: accent)),
          ),

        ]
    );
  });
}
