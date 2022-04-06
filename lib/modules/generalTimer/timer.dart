import 'package:ghambeel/modules/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/main.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'dart:async';
import 'package:simple_timer/simple_timer.dart';

import '../../theme.dart';

class topBar extends AppBar {
  final String myTitle;
  topBar({Key? key, required BuildContext context,required this.myTitle})
      : super(
  key: key,
  leading: IconButton(
  icon:  Icon(Icons.arrow_back,color: primaryText[darkMode],  ),
  onPressed: () {
  Navigator.pop(
  context,
  );
  }

  ),
  title: Text('Timer',style: TextStyle(color: primaryText[darkMode]),),
    backgroundColor: bg[darkMode],
  );
}

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key, required String title}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with SingleTickerProviderStateMixin{
  static const testDuration = Duration(minutes: 1, seconds: 5);
  Duration myTime = const Duration();
  // Timer? timer;
  // declaration
  var isRunning = false;
  var isPaused = false;
  late TimerController _timerController;
  var selectedAssignment="No task";// select default assignment here.
  late final List<DropdownMenuItem<String>> currentTaskList;

  _loadCurrentTaskList(){

    List<Task> rawTasks;
    currentTaskList = [DropdownMenuItem(child: Text("No task"),value: "No task")];
    Storage.fetchTasks().then((v) =>
    {
      rawTasks = Task.parseTasksCal(v["incomplete"], null),

      setState(() {
        for (var task in rawTasks) {
          currentTaskList.add(
              DropdownMenuItem(child: Text(task.name),value: task.name)
          );
        }
      })
    });

    //
  }

  final TextStyle buttonText = TextStyle(color:bg[darkMode]);
  final TextStyle mainText = TextStyle(color:primaryText[darkMode]);
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: darkPrimary[darkMode],
      onPrimary: lightPrimary[darkMode],
      minimumSize: const Size(50, 50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ));


  @override
  void initState() {
    super.initState();
    _loadCurrentTaskList();
    _timerController = TimerController(this);
  }

  void startTimer() {
    _timerController.restart();
    _timerController.start();
    setState(() {isRunning = true;});
  }

  void stopTimer() {
    if (isRunning) {
      _timerController.stop();
      setState(() {isRunning = false;});
    }
    else{
      _timerController.start();
    }
  }

  void pauseTimer() {
    if (!isPaused) {
      _timerController.pause();
      setState(() {isPaused = true;});
    }
    else{
      _timerController.start();
      setState(() {isPaused = false;});
    }
  }
  // void addTime() {
  //   final newTime = myTime.inSeconds - 1;
  //
  //   if (newTime < 0) {
  //     timer?.cancel();
  //   }
  //   else {
  //     setState(() {
  //       myTime = Duration(seconds: newTime);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (!isRunning)? topBar(context: context, myTitle: '',):null,
      backgroundColor: bg[darkMode],
      body: Center(
        child: createTimer(),
      )
    );
  }

  Widget createTimer() {
    String formatted(int n) => n.toString().padLeft(2, "0") ;
    // final isRunning = timer == null ? false : timer!.isActive;

    return SafeArea(
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('You are currently working on: ', style: mainText),
            DropdownButton(items:currentTaskList,
                style: mainText,
                dropdownColor: bg[darkMode],
                value:selectedAssignment,
                iconDisabledColor: accent,
                hint: const Text("Select Task", style:TextStyle(color: accent)),
                disabledHint: Text(selectedAssignment, style:TextStyle(color: accent)),
                onChanged: (!isRunning) ? (String ?nvalue)
                {
                  setState(()
                  {
                    selectedAssignment = nvalue!;
                  }
                  );
                }: null),

            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: SimpleTimer(
                        controller: _timerController,
                        duration: const Duration(seconds: 1000),
                        displayProgressIndicator: false,
                        backgroundColor: Colors.grey,
                        progressTextCountDirection: TimerProgressTextCountDirection.count_up,
                        progressTextStyle: const TextStyle(color: accent, fontSize: 60),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            isRunning
                ?Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){pauseTimer();},
                  child: !isPaused ?  Text("Pause", style:buttonText) :  Text("Resume", style:buttonText),
                  style: raisedButtonStyle,
                ),
                ElevatedButton(
                  onPressed: (){stopTimer();},
                  child: Text("Stop", style:buttonText),
                  style: raisedButtonStyle,
                )
              ],
            )
                :Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){startTimer();},
                    child: Text("Start", style:buttonText),
                    style: raisedButtonStyle,
                  ),
                ]
            ),
          ],
        ),
      )
    );
  }


}
