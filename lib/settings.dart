import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';
import 'package:settings_ui/settings_ui.dart';

class settings extends StatefulWidget {
  @override
  _settings createState() => _settings();
}

class _settings extends State<settings> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: primaryText),),
        backgroundColor: primary,
      ),
      body: SettingsTile(
        title: Text("Dark Mode"),
        onPressed: (BuildContext context) {},
      ),
    );
  }
}