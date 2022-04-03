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

  @override
  Widget build(BuildContext context) {
    if (loggedin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitles[_selectedIndex]),
          // leading: const Icon( Icons.menu, color: primaryText[darkMode]),
          backgroundColor: primary,
        ),
        drawer: Drawer(
          backgroundColor: bg[darkMode],
          child: ListView(
            children: <Widget>[
               SizedBox(
                height: 80,
                child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: accent,

                ),

                child: Text(
                  'Hello!',
                  style: TextStyle(
                    color: primaryText[darkMode],
                    fontSize: 24,

                  ),
                ),
              ),
              ),
              ListTile(
                selectedColor: bg[darkMode],
                leading: Icon(Icons.settings, color: secondaryText[darkMode],),
                title: Text('Settings', style: TextStyle(color: primaryText[darkMode]),),
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => settings())),
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
