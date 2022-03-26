import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


const __storage = FlutterSecureStorage();

class Storage {

  static Future<String?> getValue (key) async {
    return __storage.read(key: key);
  }

  static Future<void> setValue (String key, String value) async {
    return __storage.write(key: key, value: value);
  }

  static String jsonEnc (dynamic data) {
    return json.encode(data);
  }

  static dynamic jsonDec (String? str) {
    if (str == null) {
      return "";
    }
    else {
      return json.decode(str);
    }
  }

  static Future<dynamic> fetchTasks() {
    return getValue(Keys.tasks).then((v) => (jsonDec(v))["tasks"]);
  }

  static Future<void> deleteAll() async {
    return __storage.deleteAll();
  }

  static Future<void> AddTask (String title, String desc, String notes, String pr, String deadline) async {
    int newNum = -1;
    dynamic newTask = {"name":title, "priority":pr, "description":desc, "status":"incomplete", "timeAdded":DateTime.now().toString(), "deadline":deadline, "timeCompleted":""};
    
    await Storage.getValue(Keys.taskNum).then((value) => {
      if (value != null) {
        newNum = int.parse(value) + 1,
      }
    });

    await Storage.setValue(Keys.taskNum, (newNum).toString()); 

    dynamic tasks = await fetchTasks(); 

    tasks["incomplete"]["task" + newNum.toString()] = newTask;
    
    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }
}

class Keys {
  static String login = "loginStatus";
  static String tasks = "tasks";
  static String taskNum = "globalTaskNum";
}