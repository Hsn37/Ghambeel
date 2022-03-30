import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:ghambeel/theme.dart';

Widget subHeading(String heading, IconData icon, [Color col = accent]) {
  return Row(
    children: <Widget>[
      Icon(icon, color: col),
      Text(heading, style: const TextStyle(fontWeight: FontWeight.bold))
    ],
  );
}

Future<void> viewTask(Task task, BuildContext context) async {
  Color timerCol;
  if (task.priority == "0") {
    timerCol = Colors.blue;
  } 
  else if (task.priority == "1") {
    timerCol = accent;
  } 
  else {
    timerCol = Colors.red;
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task.name),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              subHeading("Description", Icons.description),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(task.description),
              ),
              subHeading("Notes", Icons.notes),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(task.notes == ""? "-":task.notes),
              ),
              subHeading(task.deadline, Icons.timer, timerCol),
            ]
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Noice!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}