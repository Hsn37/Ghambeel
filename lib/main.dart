import 'package:flutter/material.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'modules/storage/storage.dart';
import 'modules/homepage/homepage.dart';
import '../../theme.dart';
// initial varialbes setup.
void setup() {
  // the flag for whether the user is logged in or not.
  Storage.getValue(Keys.login).then((v) => {
      if (v == null) 
        Storage.setValue(Keys.login, "false")
    });

  // the tasks object to be present int the system always
  Storage.getValue(Keys.tasks).then((v) => {
      if (v == null) 
        Storage.setValue(Keys.tasks, Storage.jsonEnc({
          "tasks":{
            "completed":{
                "task0":{"name":"SampleTask", "priority":"low", "description":"Sample description", "status":"incomplete", "timeAdded":"", "timeCompleted":""}
              },
            "all":{},
            "week":{}
            }
          }))
    });

  // Global task number to be used for task keys, like task1, task2, task3 in the object.
  Storage.getValue(Keys.taskNum).then((v) => {
    if (v == null)
      Storage.setValue(Keys.taskNum, 1.toString())
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}



