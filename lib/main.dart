import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'modules/storage/storage.dart';
import 'modules/homepage/homepage.dart';
import '../../theme.dart';

// initial variables setup.
void setup() {
  // the flag for whether the user is logged in or not.
  Storage.getValue(Keys.login).then((v) => {
      if (v == null) 
        Storage.setValue(Keys.login, "false")
    });

  // the tasks object to be present int the system always
  Storage.getValue(Keys.tasks).then((v) => {
      // Priorities: 0 = low, 1 = medium, 2 = high
      // using empty string if want to overwrite the value
      Storage.setValue(Keys.tasks, Storage.jsonEnc({
          "tasks":{
            "incomplete":{
                "task0":{"name":"SampleTask", "priority":"0", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime.now().toString(), "timeCompleted":""},
                "task2":{"name":"SampleTask2", "priority":"1", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime.now().toString(), "timeCompleted":""},
                "task3":{"name":"SampleTask2", "priority":"1", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime.now().toString(), "timeCompleted":""},
                "task4":{"name":"SampleTask2", "priority":"1", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime.now().toString(), "timeCompleted":""},
                "task5":{"name":"SampleTask2", "priority":"1", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime.now().toString(), "timeCompleted":""},
              },
            "complete":{
                "task1":{"name":"SampleTask", "priority":"2", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime(2021, 2, 2, 2, 2, 2).toString(), "timeCompleted":DateTime.now().toString()},
                "task6":{"name":"SampleTask", "priority":"2", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime(2021, 2, 2, 2, 2, 2).toString(), "timeCompleted":DateTime.now().toString()},
                "task7":{"name":"SampleTask", "priority":"2", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime(2021, 2, 2, 2, 2, 2).toString(), "timeCompleted":DateTime.now().toString()},
                "task8":{"name":"SampleTask", "priority":"2", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime(2021, 2, 2, 2, 2, 2).toString(), "timeCompleted":DateTime.now().toString()},
                "task9":{"name":"SampleTask", "priority":"2", "description":"Sample description", "status":"incomplete", "timeAdded":DateTime(2021, 2, 2, 2, 2, 2).toString(), "timeCompleted":DateTime.now().toString()}
            },
            "week":{"week0":{"date":DateTime.now().toString(), "tasks":["task0"]}}
            }
          }))
    });

  // Global task number to be used for task keys, like task1, task2, task3 in the object.
  Storage.getValue(Keys.taskNum).then((v) => {
    if (v == null)
      Storage.setValue(Keys.taskNum, 1.toString())
  });

  Storage.getValue(Keys.weekNum).then((v) => {
    if (v == null)
      Storage.setValue(Keys.weekNum, 1.toString())
  });

}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Storage.setValue(Keys.tasks, "").then((p) => setup()); // when you want to flush the tasks object
  setup();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}
