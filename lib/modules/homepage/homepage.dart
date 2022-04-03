import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghambeel/theme.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'package:ghambeel/modules/utils.dart';
import 'package:ghambeel/settings.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:ghambeel/modules/calendar/calendar.dart';
import 'package:ghambeel/modules/pomodoro/pomodoroHome.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const Color navColor = Color(0xFF0097A7);
  static const Color navColorSelected = Color(0xFFFFC107);

  int _selectedIndex = 0;
  bool loggedin = true;
  @override
  void initState() {
    super.initState();
  }
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /////////////////////////////////////////////////////////
  // This is where we have our Pages inserted as widgets. Currently it contains 4 text widgets.
  /////////////////////////////////////////////////////////
  static const List<Widget> _widgetOptions = <Widget>[
    Calendar(
      title: 'Calendar',
    ),
    ToDoList(
        title:'To-Do List'
    ),
    PomodoroHome(
      title: 'Pomodoro'
    ),
    Text(
      'Index 3: Stats Page',
      style: optionStyle,
    ),
  ];
  static const List<String> _titles = <String>["Calendar", "Todo List", "pomodoro", "Statistics"];
  static const List<Widget> appBars = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onReturn() {
    setState(() {
      print("here");
      // refresh
    });
  }

  @override
  Widget build(BuildContext context) {


    if (loggedin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitles[_selectedIndex]),
          // leading: const Icon( Icons.menu, color: primaryText[darkMode]),
          backgroundColor: primary[darkMode],
        ),
        drawer: Drawer(
          backgroundColor: bg[darkMode],
          child: ListView(
            children: <Widget>[
               const SizedBox(
                height: 80,
                child: DrawerHeader(
                decoration: BoxDecoration(
                  color: accent,
                ),

                child: Text(
                  'Hello!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,

                  ),
                ),
              ),
              ),
              ListTile(
                selectedColor: bg[darkMode],
                leading: Icon(Icons.settings, color: secondaryText[darkMode],),
                title: Text('Settings', style: TextStyle(color: primaryText[darkMode]),),
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => settings())).then((_) {
                  setState(() {
                    // Call setState to refresh the page.

                    // _onItemTapped(return_index);
                  });
                  var return_index = _selectedIndex;
                  Navigator.pop(context);
                  _onItemTapped((return_index+1)%4);
                  Future.delayed(const Duration(milliseconds: 10), () {
                    _onItemTapped((return_index));
                  });


                }),
              ),
          ListTile(
            selectedColor: bg[darkMode],
            leading: Icon(Icons.logout, color: secondaryText[darkMode],),
            title: Text('Logout', style: TextStyle(color: primaryText[darkMode]),),
            onTap: () async {
              bool status = await showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Logout?", style: TextStyle(color: primaryText[darkMode])),
                  backgroundColor: bg[darkMode],
                  content: Text("You may want to backup first.", style: TextStyle(color: primaryText[darkMode])),

                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child:Text("Yes", style: TextStyle(color: primaryText[darkMode])),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                      child:const Text("No", style: TextStyle(color: accent)),
                    ),

                  ]
                );
              });

              print("Logout:");
              print(status);
            },
          ),
            ],
          ),
        ),
        body: Center(
            child: _widgetOptions.elementAt(_selectedIndex)
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: bg[darkMode],
            type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.event_note,
                color: _selectedIndex == 0 ? navColorSelected : navColor),
                label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted,
                color: _selectedIndex == 1 ? navColorSelected : navColor),
                label: "ToDo"),
            BottomNavigationBarItem(icon: Icon(Icons.timer,
                color: _selectedIndex == 2 ? navColorSelected : navColor),
                label: "Pomodoro"),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart,
                color: _selectedIndex == 3 ? navColorSelected : navColor),
                label: "Statistics"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: navColorSelected,
          unselectedItemColor: primaryText[darkMode],
          onTap: _onItemTapped,
        ),
      );
    }
    else {
      return const LoginPage();
    }
  }
}
