import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const testDuration = Duration(minutes: 1, seconds: 5);
  Duration myTime = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void startTimer(duration) {
    myTime = testDuration;
    timer = Timer.periodic(const Duration(seconds: 1), (_){addTime();});
  }

  void stopTimer(isRunning) {
    if (isRunning) {
      timer?.cancel();
      setState(() {});
    }
  }

  void addTime() {
    final newTime = myTime.inSeconds - 1;

    if (newTime < 0) {
      timer?.cancel();
    }
    else {
      setState(() {
        myTime = Duration(seconds: newTime);
      });
    }
  }

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
    String minutes = formatted(myTime.inMinutes.remainder(60));
    String seconds = formatted(myTime.inSeconds.remainder(60));
    final isRunning = timer == null ? false : timer!.isActive;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: myTime.inSeconds / testDuration.inSeconds,
                      valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                      strokeWidth: 12,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$minutes:$seconds',
                    style: const TextStyle(fontSize: 60),
                  ),
                )
              ],
            ),
          ),
          isRunning
          ?Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (){stopTimer(isRunning);},
                child: isRunning ? const Text("Pause") : const Text("Resume"),
              ),
              ElevatedButton(
                onPressed: (){},
                child: const Text("Stop"),
              )
            ],
          )
          :Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (){startTimer(testDuration);},
                child: const Text("Start"),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
