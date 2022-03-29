import 'package:flutter/material.dart';

class PomodoroHome extends StatefulWidget {
  const PomodoroHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PomodoroHomeState createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color.fromRGBO(197, 244, 250, 1), Color.fromRGBO(255, 223, 126, 1)]
        )
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: TextButton(
                  onPressed: (){},
                  child: const Text("Pomodoro"),
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: TextButton(
                  onPressed: (){},
                  child: const Text("Timer"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}