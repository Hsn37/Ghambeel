import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'dart:convert';

import '../utils.dart';


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

  static Future<void> AddTask (String title, String desc, String notes, String pr, String deadline, String imgname) async {
    int newNum = -1;
    dynamic newTask = {"name":title, "priority":pr, "description":desc, "notes":notes, "status":"incomplete", "timeAdded":getNowDateTime(), "deadline":deadline, "timeCompleted":"", "imgname":imgname};
    
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

  static Future<void> EditTask (Task task) async {
    dynamic editedTask = {"name":task.name, "priority":task.priority, "description":task.description, "notes":task.notes, "status":task.status, "timeAdded":task.timeAdded, "deadline":task.deadline, "timeCompleted":task.timeCompleted, "imgname": task.imgname};
    
    dynamic tasks = await fetchTasks();
    
    tasks[task.status][task.taskId] = editedTask;

    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }

  static Future<void> markTaskDone (Task task) async {
    dynamic tasks = await fetchTasks();

    dynamic t = tasks["incomplete"][task.taskId];
    tasks["incomplete"].remove(task.taskId);

    t["status"] = "complete";

    tasks["complete"][task.taskId] = t;

    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }

  static Future<void> markTaskunDone (Task task) async {
    dynamic tasks = await fetchTasks();

    dynamic t = tasks["complete"][task.taskId];
    tasks["complete"].remove(task.taskId);

    t["status"] = "incomplete";

    tasks["incomplete"][task.taskId] = t;

    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }

  static Future<void> deleteTask (Task task) async {
    dynamic tasks = await fetchTasks();

    tasks[task.status].remove(task.taskId);

    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }
}

class Keys {
  static String login = "loginStatus";
  static String tasks = "tasks";
  static String taskNum = "globalTaskNum";
}