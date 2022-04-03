import 'package:flutter/material.dart';
import 'package:ghambeel/modules/pomodoro/pomodoro.dart';
import 'package:ghambeel/theme.dart';
import 'package:ghambeel/modules/generalTimer/timer.dart';

class PomodoroHome extends StatefulWidget {
  const PomodoroHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PomodoroHomeState createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Color.fromARGB(255, 46, 255, 92),

    //primary: lightPrimary[darkMode],

    minimumSize: const Size(250, 100),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
  final TextStyle myTextStyle = TextStyle(
    color: primaryText[darkMode],
  );

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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroTimer(title:'Pomodoro Timer')));
                  },
                  child: Text(
                    "Pomodoro",
                    style: myTextStyle,
                  ),

                  style: raisedButtonStyle
            ),
              ElevatedButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CountdownTimer()));},
                  child: Text(
                    "Timer",
                    style: myTextStyle,
                  ),
                  style: raisedButtonStyle
              ),
            ],
          ),
        ),
      ),
    );
  }
}