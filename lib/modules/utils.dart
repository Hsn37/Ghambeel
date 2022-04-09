import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

final today = DateTime.now();
final firstDay = DateTime(today.year, today.month - 10, today.day);
final lastDay = DateTime(today.year, today.month + 10, today.day);
final String serverUrl = 'http://74.207.234.113:8080';

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

String getFormattedDatetime(DateTime t) {
  return t.toString().split(".")[0];
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

Future alertDialog(title, message, context) {
  return showDialog(context: context, builder: (context){
    return AlertDialog(
        elevation: 8.0,
        title:Container(
                  child:  Text(title, style: TextStyle(color: accent)),
                  //scolor: Colors.yellow,
          ),
        backgroundColor: bg[darkMode],
        content: Text(message, style: TextStyle(color: primaryText[darkMode])),

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
                decoration: BoxDecoration(
                //border: Border.all(color: lightPrimary[darkMode]),
                //color: lightPrimary[darkMode],
              ),
              
              child:Text("OK", style: TextStyle(color: accent)),
            )
            
          ),
        ]
    );
  });
}

Future<Response> makePost(data, table, serverUrl) async {
  return post(
    Uri.parse(serverUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'table' : table,
      'data' : data
    }),
  );
}

void postData(data, table, serverUrl) async {
  var response = await makePost(data, table, serverUrl);
  if (response.body != "")
    Map responseData = jsonDecode(response.body);
}

Future<Map> getData(url) async {
  // Replace the url inside with https://localhost:{port}/?username=admin&password=123 (try either localhost or 10.0.0.2)
  Response response = await get(Uri.parse(url));
  Map data = {};
  if (response.body != "") {
    data = jsonDecode(response.body);
  }
  return data;
}

Future<void> doBackup(serverUrl) async {
  var temp = await Storage.fetchTasks();
  print(temp);
  final prefs = await SharedPreferences.getInstance();
  final username = await prefs.getString("username");
  var data = jsonEncode({
    "username" : username,
    "data" : jsonEncode(temp)
  });
  postData(data, "Tasks", serverUrl);
}

Future<void> sendScores(serverUrl) async {
  var temp = await Storage.fetchTasks();
  final prefs = await SharedPreferences.getInstance();
  final username = await prefs.getString("username");
  final complete = temp['complete'];
  print(complete);
  var total = 0;
  var cumPriority = [];
  var cumTimeTaken = [];
  var cumMonth = [];
  for (var key in complete.keys) {
    var current = complete[key];
    var added = DateTime.parse(current['timeAdded']);
    var completed = DateTime.parse(current['timeCompleted']);
    var priority = current['priority'];
    var month = completed.month;
    var timeTaken = completed.difference(added).inSeconds;
    cumPriority.add(priority);
    cumTimeTaken.add(timeTaken);
    cumMonth.add(month);
  }

  var data = jsonEncode({
    "username" : username,
    "data" : jsonEncode({
      "priority" : cumPriority,
      "timeTaken" : cumTimeTaken,
      "month" : cumMonth
    })
  });
  postData(data, "Stats", serverUrl);
}

Future<Map> getScores() async {
  final prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('username') ?? "";
  var month = DateTime.now().month - 1;
  Map data = await getData("http://74.207.234.113:8080/?username="+user+"&scores="+month.toString());
  return data;
}

Future<void> changePass(password) async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username') ?? "";
  var data = jsonEncode({
    "username" : username,
    "data" : jsonEncode({
      "password" : password
    })
  });
  postData(data, "Password", serverUrl);
}