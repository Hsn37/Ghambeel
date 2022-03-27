import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:ghambeel/modules/calendar/addtask.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import '../utils.dart';
import '../../theme.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
   CalendarFormat _calendarFormat = CalendarFormat.month; // month format for calendar widget
  // States:
  late Map<DateTime, List<Task>?> sortedTasks;
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
    _selectedDay = DateTime.now();
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
        floatingActionButton: FloatingActionButton(
          //splashColor: plusFloatCol,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTask(title: 'Add A Task')),
            ).then((T) => {
              setState(() {
                sortedTasks = {};
                fetchData = true;
                getEvents();
              })
            });
            // Add your onPressed code here! function call to creatTask
          },
          backgroundColor: toDoIconCols,//Colors.teal.shade800,
          focusColor: Colors.blue,
          foregroundColor: bg, //Colors.amber,
          hoverColor: accent, //Colors.green,
          //splashColor: Colors.tealAccent,

          child: const Icon(Icons.add ),
        ),
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
              color: accent,
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
                if (_todayIncomplete.value.isNotEmpty) {
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
                      onTap: () => print(value[index].timeAdded),
                      title: Text(value[index].name),
                      subtitle: Text(value[index].description),
                    ),
                  );
                },
                );
              };
              {return const Text("No tasks here!");}},
            )
          )]
        ),
      );
  }

  List<Task> _getEventsToday(DateTime day){

    DateFormat format = DateFormat("yyyy-MM-dd");
    var idx =DateTime.parse(format.format(DateTime.parse(day.toString().split(" ")[0])));
    return sortedTasks[idx] ?? [];
  }

  getEvents() {
    Storage.fetchTasks().then((v) =>
    {
      rawTasks = Task.parseTasksCal(v["incomplete"], null),

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
        DateFormat format = DateFormat("yyyy-MM-dd");
        var i = format.format(DateTime.parse(task.deadline.split(" ")[0]));
        var idx = DateTime.parse(i);
        if (sortedTasks[idx] != null) {
          sortedTasks[idx]?.add(task);
        } else {
          sortedTasks[idx] = [task];
        }
        sortedTasks[idx] = sortedTasks[idx]?.toSet().toList();
      }
      print(sortedTasks);
    });

  }


}
//
