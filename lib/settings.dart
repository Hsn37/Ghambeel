import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';
import 'package:settings_ui/settings_ui.dart';

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
        backgroundColor: primary,
      ),
      body: SwitchListTile(
        title: const Text("Dark Mode"),
        onChanged: (value){
          setState((){
            isDark = value;
            darkMode = value ? 1 : 0;
            print(darkMode);
            //
          });

        },
        value: isDark,
      ),
    );
  }
}