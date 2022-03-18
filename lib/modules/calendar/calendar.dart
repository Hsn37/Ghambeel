import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import '../utils.dart';
import '../../theme.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>{
  final CalendarFormat _calendarFormat = CalendarFormat.month;  // month format for calendar widget
  // States:
  DateTime _focusedDay = DateTime.now(); //
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

    body: TableCalendar(
    firstDay: firstDay, // first day in calendar (defined in utils)
    lastDay: lastDay,
    focusedDay: _focusedDay, // selected day
    calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return _selectedDay == day;
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (_selectedDay != selectedDay) { // Change selected day when a day is clicked
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
    calendarStyle: const CalendarStyle(
      weekendTextStyle: TextStyle(color: accent),
      // highlighted color for today
      todayDecoration: BoxDecoration(
      color: lightPrimary,
      shape: BoxShape.circle,
         ),
      todayTextStyle: TextStyle(color: primaryText),
      selectedDecoration: BoxDecoration(
        color: darkPrimary,
        shape: BoxShape.circle,
      ),
      ),
    ),
    );
  }
}