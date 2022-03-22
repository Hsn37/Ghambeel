import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import '../utils.dart';
import '../../theme.dart';

class Task {
  String name, priority, description, status, timeAdded, timeCompleted;

  Task(this.name, this.priority, this.description, this.status, this.timeAdded, this.timeCompleted);

  static List<Task> parseTasks(tasks) {
    var l = <Task>[];
    tasks.forEach((k, v) => {
      l.add(Task(v["name"], v["priority"], v["description"], v["status"], v["timeAdded"], v["timeCompleted"]))
    });

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
  final CalendarFormat _calendarFormat = CalendarFormat
      .month; // month format for calendar widget
  // States:
  DateTime _focusedDay = DateTime.now(); //
  DateTime? _selectedDay;
  ValueNotifier<List<Task>> incompleteTasks = ValueNotifier([Task("","","","","","")]);
  var completedTasks = <Task>[];
  // var incompleteTasks = <Task>[];

  static var itemsComp = <Task>[];
  static var itemsUncomp = <Task>[];

  static int presentComp = 0;
  static int perPageComp = 3;
  static int presentUncomp = 0;
  static int perPageUncomp = 3;

  var fetchData = true;

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
          onDaySelected: (selectedDay, focusedDay) { // What happens when we click on a day
            if (_selectedDay !=
                selectedDay) { // Change selected day when a day is clicked
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
            getEventsToday(selectedDay);
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
              valueListenable: incompleteTasks,
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
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('hello'),
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

  getEventsToday(DateTime day) {
    Storage.fetchTasks().then((v) =>
    {
      incompleteTasks = ValueNotifier(Task.parseTasks(v["incomplete"])),
      completedTasks = Task.parseTasks(v["complete"]),
      setState(() =>
      {
        fetchData = false,
        itemsComp.addAll(
            completedTasks.getRange(presentComp, presentComp + perPageComp)),
        presentComp = presentComp + perPageComp,
        itemsUncomp.addAll(incompleteTasks.value.getRange(
            presentUncomp, presentUncomp + perPageUncomp)),
        presentUncomp = presentUncomp + perPageUncomp
      })
    });
  }


}
//
