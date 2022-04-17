import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';
import 'modules/utils.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:ghambeel/modules/login/changepass.dart';

import 'modules/calendar/calendar.dart';
import 'modules/todolist/todolist.dart';

var isDark;

class settings extends StatefulWidget {

  @override
  _settings createState() => _settings();

}


class _settings extends State<settings> {
  bool backing_up = false;
  bool recovering = false;
  @override
  Widget build(BuildContext context) {
    // darkMode = isDark ? 1 : 0;
    return Scaffold(
      backgroundColor: bg[darkMode],
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: primary[darkMode],
      ),
      body: Column(
          children:[SwitchListTile(
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

        !backing_up ? ListTile(
          title: Text("Backup", style: TextStyle(color: primaryText[darkMode]),),
            contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
          onTap: () async {
            setState(() {
              backing_up = true;
            });
            await doBackup(serverUrl);
            await sendScores(serverUrl);
            setState(() {
              backing_up = false;
            });
          }
        ): CircularProgressIndicator(),
            !recovering ? ListTile(
                title: Text("Recover", style: TextStyle(color: primaryText[darkMode]),),
                contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                onTap: () async {
                  var status = await youSure("Recover?", "This may overwrite your current data." , context);
                  if (status){
                    setState(() {
                      recovering = true;
                    });
                    await Storage.recoverTasks();
                    setState(() {
                      recovering = false;
                    });

                  }}) :
            CircularProgressIndicator(),
            ListTile(
                title: Text("Change Password", style: TextStyle(color: primaryText[darkMode]),),
                contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePage()));
                }
            )
          ]
      )
    );
  }
}