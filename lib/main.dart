import 'package:flutter/material.dart';
import 'modules/login/login.dart';
import 'modules/todolist/todolist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: "FLutter"),
    );
  }
}

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
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /////////////////////////////////////////////////////////
  // This is where we have our Pages inserted as widgets. Currently it contains 4 text widgets.
  /////////////////////////////////////////////////////////
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Calendar',
      style: optionStyle,
    ),
    ToDoList(
      title:'To-Do List'
    ),
    Text(
      'Index 2: Pomodoro',
      style: optionStyle,
    ),
    Text(
      'Index 3: Stats Page',
      style: optionStyle,
    ),
  ];
  static const List<String> _titles = <String>["Calendar", "Todo List", "Pomodoro", "Statistics"];
  static const List<Widget> appBars = <Widget>[];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ToDoList.topBar,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.event_note, color: _selectedIndex == 0? navColorSelected:navColor), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted, color: _selectedIndex == 1? navColorSelected:navColor), label: "ToDo"),
          BottomNavigationBarItem(icon: Icon(Icons.timer, color: _selectedIndex == 2? navColorSelected:navColor), label: "Pomodoro"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart, color: _selectedIndex == 3? navColorSelected:navColor), label: "Statistics"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: navColorSelected,
        onTap: _onItemTapped,
      ),
    );
  }
}


