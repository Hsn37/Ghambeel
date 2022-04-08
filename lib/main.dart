import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghambeel/modules/pomodoro/pomodorosettings.dart';
import 'package:ghambeel/theme.dart';
import 'package:ghambeel/settings.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:ghambeel/modules/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'modules/calendar/calendar.dart';
import 'modules/notifications/notifications.dart';
import 'modules/storage/storage.dart';
import 'modules/homepage/homepage.dart';
import 'modules/pomodoro/pomodoroHome.dart';
import '../../theme.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';


// initial variables setup.
Future setup() {
  // the flag for whether the user is logged in or not.
  var p1 = Storage.getValue(Keys.login).then((v) => {
      if (v == null) 
        Storage.setValue(Keys.login, "false")
    });

  // the tasks object to be present int the system always
  var p2 = Storage.getValue(Keys.tasks).then((v) => {
      // Priorities: 0 = low, 1 = medium, 2 = high
      // using empty string if want to overwrite the value
      
      if (v == null || v == "") {
        Storage.setValue(Keys.tasks, Storage.jsonEnc({
            "tasks":{
              "incomplete":{
                  "task0":{"name":"First Task", "priority":"0", "description":"Take a tour of our app", "notes": "", "status":"incomplete", "timeAdded":getNowDateTime(), "deadline":getNowDateTime(), "timeCompleted":"", "imgname":""},
                },
              "complete":{},
              },
            }))
      }
    });

  // Global task number to be used for task keys, like task1, task2, task3 in the object.
  var p3 = Storage.getValue(Keys.taskNum).then((v) => {
    if (v == null)
      Storage.setValue(Keys.taskNum, 0.toString())
  });

  var p4 = getApplicationDocumentsDirectory().then((v) => AppDirectoryPath = v.path);

  var p5 = Notifications.init();

  var p6 = Storage.getValue(Keys.timespent).then((v) => {
    if (v == null)
      Storage.setValue(Keys.timespent, Storage.jsonEnc({}))
  });

  return Future.wait(<Future>[p1, p2, p3, p4, p5, p6]);
}

void main() {
  darkMode = 0;
  isDark = false;
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for the setup to finish first. then run the app
  
  // when you want to refresh the storage, run this
  // Storage.deleteAll().then((v) => Storage.recoverTasks()).then((value) => runApp(const MyApp()));
  Storage.deleteAll().then((v) => setup()).then((v) => runApp(const MyApp()));
  Notifications.show("Mot Quote", "Kaam karlo bhai", NotifID.motquote);
  
  // else this one.
  // setup().then((v) => runApp(const MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        disabledColor: Colors.grey,
      ),
      // home: const MyHomePage(title: "TodoList"),
      home: LoginPage(),
      // home: ToDoList(title: "TodoList"),
    );
  }
}
