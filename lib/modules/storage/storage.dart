import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'dart:convert';
import 'package:ghambeel/modules/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static int getMax(data) {
    int max = 0;
    var complete = data['complete'];
    var incomplete = data['incomplete'];
    for (var i = 0; i < complete.length; i++) {
      var taskNum = complete[i]['taskNum'];
      var current = int.parse(taskNum[taskNum.length-1]);
      if (current > max) {
        max = current;
      }
    }
    for (var i = 0; i < incomplete.length; i++) {
      var taskNum = incomplete[i]['taskNum'];
      var current = int.parse(taskNum[taskNum.length-1]);
      if (current > max) {
        max = current;
      }
    }
    return max;
  }

  static Future<void> recoverTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('username') ?? "";
    Map data = await getData("http://74.207.234.113:8080/?username="+user+"&recovery=1");
    var complete = data['complete'];
    var incomplete = data['incomplete'];
    int newTotal = getMax(data);
    await Storage.setValue(Keys.taskNum, (newTotal).toString());

    dynamic tasks = {"complete" : {}, "incomplete" : {}};

    if (complete.length > 0) {
      for (var i = 0; i < complete.length; i++) {
        var taskNum = complete[i]['taskNum'];
        var details = jsonDecode(complete[i]['details']);
        tasks["complete"][taskNum] = details;
      }
    }

    if (incomplete.length > 0) {
      for (var i = 0; i < incomplete.length; i++) {
        var taskNum = incomplete[i]['taskNum'];
        var details = jsonDecode(incomplete[i]['details']);
        tasks["incomplete"][taskNum] = details;
      }
    }

    return await Storage.setValue(Keys.tasks, jsonEnc({"tasks":tasks}));
  }
}

class Keys {
  static String login = "loginStatus";
  static String tasks = "tasks";
  static String taskNum = "globalTaskNum";
}

// initialized in the app setup function.
String AppDirectoryPath = "";