import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import '../utils.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.title}) : super(key: key);
  final String title;

  static final topBar = AppBar(
    leading: const Icon( Icons.menu, color:Color.fromARGB(255, 47, 10, 180)),
    title: const Text('Calendar'),

    backgroundColor: Colors.purple,
  );
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Calendar'),
    ),
    body: TableCalendar(
    firstDay: firstDay,
    lastDay: lastDay,
    focusedDay: _focusedDay,
      ),
    );
  }
}