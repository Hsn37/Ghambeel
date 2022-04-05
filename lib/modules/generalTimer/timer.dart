import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_timer/simple_timer.dart';

import '../../theme.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

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
    currentTaskList = [
      DropdownMenuItem(child: Text("No task"),value: "No task"),
      DropdownMenuItem(child: Text("USA"),value: "USA"),
      DropdownMenuItem(child: Text("Canada"),value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
    ];

    //
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: primary[darkMode],

      primary: lightPrimary[darkMode],
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
            const Text('You are currently working on: '),
            DropdownButton(items:currentTaskList,
                value:selectedAssignment,
                iconDisabledColor: accent,
                hint: const Text("Select Task"),
                disabledHint: Text(selectedAssignment),
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
                  child: !isPaused ? const Text("Pause") : const Text("Resume"),
                  style: raisedButtonStyle,
                ),
                ElevatedButton(
                  onPressed: (){stopTimer();},
                  child: const Text("Stop"),
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
                    child: const Text("Start"),
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
