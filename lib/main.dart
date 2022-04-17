import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';
import 'package:ghambeel/settings.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'package:ghambeel/modules/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'modules/notifications/notifications.dart';
import 'modules/storage/storage.dart';
import '../../theme.dart';
import 'dart:math';


String getrandomqot(){
  var rand = new Random();
  int i = rand.nextInt(notifs_dataset.length);
  String randomString = notifs_dataset[i];
  print(randomString);
  return randomString;
}


// our background services
void backgroundService (HeadlessTask task) async {

  String taskId = task.taskId;
  bool isTimeout = task.timeout;

  if (isTimeout) {
    Notifications.show("Background service Timeout!!!", "Run at: ${getNowDateTime()}", NotifID.alert);
    BackgroundFetch.finish(taskId);
    return;
  }  

  var data = await Storage.getValue(Keys.bgservice).then((value) => Storage.jsonDec(value));
  var t = DateTime.now();

  // backup
  if (t.difference(DateTime.parse(data["backup"]["lastTime"])).inDays.abs() > 0) {
    // check for internet and backup
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        doBackup(serverUrl);
        sendScores(serverUrl);
        data["backup"]["lastTime"] = getFormattedDatetime(DateTime(t.year, t.month, t.day, 12));

        Notifications.show("Backup", "Your data was backed up!", NotifID.backup);
      }
    } on SocketException catch (_) {}
  }

  // motivational quote
  if (t.difference(DateTime.parse(data["quote"]["lastTime"])).inDays.abs() > 0) {
    var motqottoshow = getrandomqot();
    Notifications.show("Quote of the day", motqottoshow, NotifID.motquote);
    data["quote"]["lastTime"] = getNowDateTime();
  }

  // deadlines
  if (t.difference(DateTime.parse(data["deadline"]["lastTime"])).inDays.abs() > 0) {
    var tasks = await Storage.fetchTasks().then((value) => value["incomplete"]);
    int counter = 0;
    int counter2 = 0;

    tasks.forEach((k, v)  {
      if (v["deadline"] == "")
        return;
        
      var d = DateTime.tryParse(v["deadline"])!.difference(t).inDays;
      
      if (d == 0) {
        counter++;
      }
      else if (d < 0) {
        counter2++;
      }
    });

    if (counter > 0 || counter2 > 0)
      Notifications.show(
        "Approaching Deadlines", 
        "${counter > 0? "You have ${counter} ${counter > 1? "tasks":"task"} due in less than 24 hours!":""}" +
        "${counter2 > 0? "You have missed the deadline for ${counter2} ${counter2 > 1? "tasks":"task"}":""} You might want to have a look at them.", 
        NotifID.deadline);

    data["deadline"]["lastTime"] = getNowDateTime();
  }

  Storage.setValue(Keys.bgservice, Storage.jsonEnc(data));

  BackgroundFetch.finish(taskId);
}

// initial variables setup.
Future setup() async {
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

  var p6 = Storage.getValue(Keys.timeSpentPerTask).then((v) => {
    if (v == null)
      Storage.setValue(Keys.timeSpentPerTask, Storage.jsonEnc({}))
  });

  var p7 = BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
    ), backgroundService,
    (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });

  var p8 = Storage.getValue(Keys.bgservice).then((value) {
    var temp = DateTime.now();
    DateTime lastQuote = DateTime(temp.year, temp.month, temp.day, 10);
    DateTime lastBackup = DateTime(temp.year, temp.month, temp.day, 12);
    DateTime lastReminder = DateTime(temp.year, temp.month, temp.day, 9);

    if (value == null) {
      print("GOT HEREEEEEE");
      Storage.setValue(Keys.bgservice, Storage.jsonEnc({
        "quote":{"lastTime":getFormattedDatetime(lastQuote)},
        "backup":{"lastTime":getFormattedDatetime(lastBackup)},
        "deadline":{"lastTime":getFormattedDatetime(lastReminder)}
      }));
    }
  });

  var p9 = Storage.getValue(Keys.timeSpentPerDay).then((v) => {
    if (v == null)
      Storage.setValue(Keys.timeSpentPerDay, Storage.jsonEnc({}))
  });

  // Pomodoro settings.
  var p10 = Storage.setValue("cft","25").then((value) => Storage.setValue("sbt","5")).then((value) => Storage.setValue("lbt","10")).then((value) => 
    Storage.setValue("cnc","4")).then((value) => Storage.setValue("lba","2"));

  return Future.wait(<Future>[p1, p2, p3, p4, p5, p6, p7, p8, p9, p10]);
}

void main() {
  darkMode = 0;
  isDark = false;
  WidgetsFlutterBinding.ensureInitialized();

  ///////////////////////////////////////////////////////////////////
  // RUN THIS IF YOU WANT TO CLEAR OUT THE STORAGE AND START AFRESH
  ///////////////////////////////////////////////////////////////////
  // Storage.deleteAll().then((v) {
  //   setup().then((v2) {
  //     backgroundService(HeadlessTask("customtask", false));
  //     BackgroundFetch.registerHeadlessTask(backgroundService);
  //     runApp(const MyApp());
  //   });
  // });

  setup().then((v) {
    backgroundService(HeadlessTask("customtask", false));
    BackgroundFetch.registerHeadlessTask(backgroundService);
    Storage.getValue(Keys.bgservice).then((v) => print("BACKGROUND SERVICE" + v.toString()));
    runApp(const MyApp());
  });
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
