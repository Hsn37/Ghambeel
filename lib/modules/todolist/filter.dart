import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';

List<String> options = <String>["Deadline", "Priority", "Start Time"];

Widget listOption(BuildContext context, String option, int value, int currentFilter) {
  return (
    TextButton(
      child: Text(option),
      style: value == currentFilter?
              TextButton.styleFrom(backgroundColor: accent):null,
      onPressed: () {
        Navigator.of(context).pop(value);
      },
    )
  );
}

Future<int?> filterTasks(BuildContext context, int currentFilter) {

  return showDialog<int>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Sort Tasks"),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 1; i <= options.length; i++)
                listOption(context, options[i-1], i, currentFilter) 
            ]
          ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(-1);
            },
          ),
        ],
      );
    },
  );
}