import 'package:ghambeel/modules/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/main.dart';
import 'package:ghambeel/modules/utils.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'dart:async';
import 'package:simple_timer/simple_timer.dart';
import 'package:ghambeel/modules/storage/storage.dart';

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
  
  Duration timeElapsed = const Duration();

  var isRunning = false;
  var isPaused = false;
  late TimerController _timerController;
  late Task selectedAssignment;// select default assignment here.
  late final List<DropdownMenuItem<Task>> currentTaskList;

  bool noTasks = false;
  bool fetchData = true;

  _loadCurrentTaskList(List<Task> list) {

    currentTaskList = list.map((e) => DropdownMenuItem(child: Text(e.shortName()), value: e)).toList();
    selectedAssignment = list[0];
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
    // _loadCurrentTaskList();
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
      print(timeElapsed);
      Storage.AddTimeSpent(selectedAssignment, timeElapsed);
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
    if (fetchData) {
      var start = DateTime.now();
      Storage.fetchTasks().then((v) {
        var list = Task.parseTasks(v["incomplete"]);
        
        if (list.length == 0) {
          noTasks = true;          
        }
        else {
          _loadCurrentTaskList(list);
        }
        
        if (noTasks) {
            Navigator.pop(context);
            alertDialog("Voila", "You currently have no tasks to work on", context);
        }
        else
          Timer(Duration(milliseconds: 1000 - DateTime.now().difference(start).inMilliseconds), () => setState(() => {
            fetchData = false,
          }));
      });

      return Loading();
    }
    else {
      return Scaffold(
          appBar: (!isRunning)? topBar(context: context, myTitle: '',):null,
        backgroundColor: bg[darkMode],
        body: Center(
          child: createTimer(),
        )
      );
    }
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
                disabledHint: Text(selectedAssignment.shortName(), style:TextStyle(color: accent)),
                onChanged: (!isRunning) ? (Task? nvalue)
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
                        valueListener: (e) => timeElapsed = e,
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
