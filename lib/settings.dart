import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';

import 'modules/calendar/calendar.dart';
import 'modules/todolist/todolist.dart';

var isDark;

class settings extends StatefulWidget {

  @override
  _settings createState() => _settings();

}


class _settings extends State<settings> {

  @override
  Widget build(BuildContext context) {
    // darkMode = isDark ? 1 : 0;
    return Scaffold(
      backgroundColor: bg[darkMode],
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: primary[darkMode],
      ),
      body: SwitchListTile(
        activeColor: accent,
        contentPadding: const EdgeInsets.symmetric(vertical:20, horizontal: 20),
        subtitle: Text("You may need to switch pages for effects to take place.", style: TextStyle(color: primaryText[darkMode]),),
        title: Text("Dark Mode", style: TextStyle(color: primaryText[darkMode]),),
        onChanged: (value){
          setState((){
            isDark = value;
            darkMode = value ? 1 : 0;
            //
          });
          // Navigator.pop(context);
        },
        value: isDark,
      ),
    );
  }
}