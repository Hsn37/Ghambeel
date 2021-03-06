import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:ghambeel/theme.dart';
import 'package:path_provider/path_provider.dart';

import '../utils.dart';

Widget subHeading(String heading, IconData icon, [Color col = accent]) {
  return Row(
    children: <Widget>[
      Icon(icon, color: col),
      Text(heading, style: TextStyle(fontWeight: FontWeight.bold, color: primaryText[darkMode]))
    ],
  );
}

File? image;

Future<void> displayImg(Task task) async{
  print(task.imgname);
  if (task.imgname == ""){
    image = null;
    return;
  }
  try {
    String path = AppDirectoryPath + "/" + task.imgname;
    final File? localImage = File(path);
    print(path);
    image = localImage;
  } catch(e)
  {
    image = null;
    return;
  }
}



Future<void> viewTask(Task task, BuildContext context) async {
  displayImg(task);
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
        title: Text(task.name, style: TextStyle(color: primaryText[darkMode]),),
        backgroundColor: bg[darkMode],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              subHeading("Description", Icons.description),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(task.description == ""? "-":task.description, style: TextStyle(color: primaryText[darkMode])),
              ),
              subHeading("Notes", Icons.notes),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(task.notes == ""? "-":task.notes, style: TextStyle(color: primaryText[darkMode])),
              ),
              subHeading(task.timeAdded, Icons.create, Color.fromARGB(255, 172, 166, 166)),
              subHeading(task.deadline, Icons.timer, timerCol),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: (image == null) ? null : Image.file(image!, width:160, height:160),
            )]
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