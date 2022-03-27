import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import '../utils.dart';
import '../../theme.dart';


class Task {
  String name, priority, description, status, timeAdded, deadline, timeCompleted;

  Task(this.name, this.priority, this.description, this.status, this.timeAdded, this.deadline,this.timeCompleted);

  static List<Task> parseTasks(tasks, day) {
    var l = <Task>[];
    tasks.forEach((k, v) => {
      if (day.toString().split(" ")[0] == v["timeAdded"].split(" ")[0] || (day == null)){
      l.add(Task(v["name"], v["priority"], v["description"], v["status"], v["timeAdded"], v["deadline"], v["timeCompleted"]))}
    });
    if (l.isEmpty){
      l = [];
    }
    return l;
  }
}


class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
   CalendarFormat _calendarFormat = CalendarFormat.month; // month format for calendar widget
  // States:
  late final Map<DateTime, List<Task>?> sortedTasks;
  DateTime _focusedDay = DateTime.now(); //
  DateTime? _selectedDay;
  late final ValueNotifier<List<Task>> _todayIncomplete;

  var rawTasks = <Task>[];


  var fetchData = true;

  @override
  void initState() {
    super.initState();
    sortedTasks = {};
    getEvents();
    _selectedDay = _focusedDay;
    sortEvents();
    _todayIncomplete = ValueNotifier(_getEventsToday(_selectedDay!));
  }

  @override
  void dispose() {
    _todayIncomplete.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        body: Column(
          children: [TableCalendar(
          firstDay: firstDay,

          // first day in calendar (defined in utils)
          lastDay: lastDay,
          focusedDay: _focusedDay,

          // selected day
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return _selectedDay == day;
          },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },

          eventLoader: _getEventsToday,
          onDaySelected: (selectedDay, focusedDay) { // What happens when we click on a day
            if (_selectedDay !=
                selectedDay) { // Change selected day when a day is clicked
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                fetchData = true;
              });
            }
            _todayIncomplete.value = _getEventsToday(selectedDay);
          },
          onPageChanged: (newday) {
            _focusedDay = newday;
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
          // event box
          const SizedBox(height:10),
          Expanded(
            child: ValueListenableBuilder<List<Task>>(
              valueListenable: _todayIncomplete,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      color: lightPrimary
                    ),
                    child: ListTile(
                      onTap: () => print(_selectedDay),
                      title: Text(value[index].name),
                      subtitle: Text(value[index].description),
                    ),
                  );
                },
                );
              },
            )
          )]
        ),
      );
  }

  List<Task> _getEventsToday(DateTime day){

    DateFormat format = DateFormat("yyyy-MM-dd");
    var idx =DateTime.parse(day.toString().split(" ")[0]);
    // // print(day);
    // // print(idx);
    // print(rawTasks);
    return sortedTasks[idx] ?? [];
  }

  getEvents() {
    Storage.fetchTasks().then((v) =>
    {
      rawTasks = Task.parseTasks(v["incomplete"], null),

      setState(()
      {
        fetchData = false;
        sortEvents();

      })

    });

  }
  sortEvents() {
    print(rawTasks);
    setState(() {
      for (var task in rawTasks) {
        print(task.name);
        DateFormat format = DateFormat("yyyy-MM-dd");
        var i = format.format(DateTime.parse(task.timeAdded.split(" ")[0]));
        // print(i);
        var idx = DateTime.parse(i);
        print(idx);
        if (sortedTasks[idx] != null) {
          sortedTasks[idx]?.add(task);
        } else {
          sortedTasks[idx] = [task];
        }
        sortedTasks[idx] = sortedTasks[idx]?.toSet().toList();
      }


    });

  }


}
//
