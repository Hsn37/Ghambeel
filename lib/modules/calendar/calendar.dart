import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:ghambeel/modules/todolist/viewtasks.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:ghambeel/modules/todolist/addtask.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat
      .month; // month format for calendar widget
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
    _selectedDay = _focusedDay;
    _todayIncomplete = ValueNotifier(_getEventsToday(_selectedDay!));
  }

  @override
  void dispose() {
    _todayIncomplete.dispose();
    super.dispose();
  }

  String shortenDescription(String x) {
    int stringLength = 25;

    if (x.length > stringLength) {
      return x.substring(0, stringLength) + "...";
    }
    else {
      return x;
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: bg[darkMode],
        floatingActionButton: FloatingActionButton(
          //splashColor: plusFloatCol,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddTask(title: 'Add A Task', deadlineMust: true,)),
            ).then((T) =>
            {
              setState(() {
                sortedTasks = {};
                fetchData = true;
                getEvents();
              })
            });
            // Add your onPressed code here! function call to creatTask
          },
          backgroundColor: toDoIconCols,
          //Colors.teal.shade800,
          focusColor: Colors.blue,
          foregroundColor: bg[darkMode],
          //Colors.amber,
          hoverColor: accent,
          //Colors.green,
          //splashColor: Colors.tealAccent,

          child: const Icon(Icons.add),
        ),
        body: Column(
            children: [Card(
              color: bg[darkMode],
              elevation: 2.0,
              shadowColor: bg[(darkMode + 1) % 2],
              margin: EdgeInsets.only(
                  left: 40.0, top: 10.0, right: 40.0, bottom: 10.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: primaryText[darkMode]),
                  formatButtonTextStyle: TextStyle(
                      color: primaryText[darkMode]),
                  leftChevronIcon: Icon(
                      Icons.chevron_left, color: primaryText[darkMode]),
                  rightChevronIcon: Icon(
                      Icons.chevron_right, color: primaryText[darkMode]),
                ),
                firstDay: firstDay,
                currentDay: DateTime.now(),
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
                onDaySelected: (selectedDay,
                    focusedDay) { // What happens when we click on a day
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
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                      color: bg[(darkMode + 1) % 2], shape: BoxShape.circle),
                  defaultTextStyle: TextStyle(color: primaryText[darkMode]),
                  weekendTextStyle: const TextStyle(color: accent),
                  // highlighted color for today
                  todayDecoration: BoxDecoration(
                    color: lightPrimary[darkMode],
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: secondaryText[darkMode]),
                  selectedDecoration: const BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),

              ),),
              // event box


              const SizedBox(height: 10),

              Expanded(
                  child: ValueListenableBuilder<List<Task>>(
                    valueListenable: _todayIncomplete,
                    builder: (context, value, _) {
                      if (_todayIncomplete.value.isNotEmpty) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height:90,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 7.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: lightPrimary[darkMode], width: 12),
                                  borderRadius: BorderRadius.circular(20),
                                  color: lightPrimary[darkMode]
                              ),
                              child: ListTile(

                                onTap: () => viewTask(value[index], context),
                                title: Row(
                                    children: [
                                      Text(value[index].name),
                                      Icon(Icons.timer,
                                        color: getColor(value[index].priority),size:20)
                                    ]),
                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [SizedBox(height: 7),Text(shortenDescription(
                                      value[index].description)),SizedBox(height: 5),
                              Text("Due: " + value[index].deadline.split(" ")[1].split(":").sublist(0,2).join(":"))]
                                ),
                              ),
                            );
                          },
                        );
                      };
                      {
                        return Text("No tasks here!",
                          style: TextStyle(color: primaryText[darkMode]),);
                      }
                    },
                  )
              )
            ]
        ),
      );
  }

  List<Task> _getEventsToday(DateTime day) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    var idx = DateTime.parse(
        format.format(DateTime.parse(day.toString().split(" ")[0])));
    return sortedTasks[idx] ?? [];
  }

  getEvents() {
    Storage.fetchTasks().then((v) =>
    {
      rawTasks = Task.parseTasksCal(v["incomplete"], null),

      setState(() {
        fetchData = false;
        sortEvents();
      })
    });
  }

  sortEvents() {
    print(rawTasks);
    print(darkMode);
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

  getColor(String priority) {
    Color timerCol;
    if (priority == "0") {
      if (darkMode == 1)
        return Color.fromRGBO(0,0, 111, 0.6);
      return Colors.blue;
    }
    else if (priority == "1")
      return accent;
    else
      return Colors.red;
  }

}