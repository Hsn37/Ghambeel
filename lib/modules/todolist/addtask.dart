import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:intl/intl.dart';
import '../../theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryText, ),           
              onPressed: () {
                  Navigator.pop(
                    context,
                  MaterialPageRoute(builder: (context) => const ToDoList(title: 'To-Do List',)),
                );
            }
            
        ),
      title: const Text('Add A Task',style: TextStyle(color: primaryText),),
      
      backgroundColor: bg,
    );
  }
class addTask extends StatefulWidget {  
  const addTask({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _AddTaskState createState() => _AddTaskState();
}
class _AddTaskState extends State<addTask>{
 
  final _formKey = GlobalKey<FormState>();
  String dropdownValuePriority = 'High';
  TimeOfDay _time = TimeOfDay(hour: 11, minute: 55);
  var tasktitle;
  var taskDesc;
  var taskNotes;
  
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }
  DateTime _date= DateTime(2022,1,1);
  void _selectDate() async {
  final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2020, 11, 17),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: topBar(context: context, myTitle: '',),
      key: _formKey,
      body: ListView(
        
        children: <Widget>[
          
          // Add TextFormFields and ElevatedButton here.
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                tasktitle=text;
            },
            decoration: const InputDecoration(
              //border: OutlineInputBorder(),
              fillColor: navColor,
              labelText: 'Task Title',
              
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskDesc=text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task Description', //check for input length or implemetnt check khudi where it is displayed
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskNotes=text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notes',
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Center(child:  DropdownButton <String>(   
              value: dropdownValuePriority,
              icon: const Icon(Icons.arrow_downward_outlined),
              elevation: 16,
              
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 5,
                width: 40,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValuePriority = newValue!;
                });
              },
              items: <String>['High', 'Medium', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),         
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectDate,
                child: const Text('Deadline for Task: Select Date'),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected time: ${DateFormat('yyyy-MM-dd').format(_date)}',
              ),
            ],
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectTime,
                child: const Text('Deadline for Task: Select Time'),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected time: ${_time.format(context)}',
              ),
            ],
          ),
        ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const addTask(title: 'Add A Task',)),
        // );
          // Add your onPressed code here! function call to creatTask
        },
        backgroundColor: toDoIconCols,//Colors.teal.shade800,
        focusColor: Colors.blue,
        foregroundColor: bg, //Colors.amber,
        hoverColor: accent,
        child: const Icon(Icons.check),
        
      ),
    );
  }
}

