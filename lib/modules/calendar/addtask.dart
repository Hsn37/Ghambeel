import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:intl/intl.dart';
import '../../theme.dart';
import 'package:select_form_field/select_form_field.dart';

// import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
//import 'package:smart_select/smart_select.dart';
// import 'package:flutter_awesome_select/flutter_awesome_select.dart';


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
class AddTask extends StatefulWidget {  
  const AddTask({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _AddTaskState createState() => _AddTaskState();
}

//class customTextBox extends TextFormField{
//   customTextBox({required this.title)
//   Widget build (){

//   }
// }

class _AddTaskState extends State<AddTask>{
  TextEditingController timeinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  List<String> options = ['High','Medium','low'];
  final List<Map<String, dynamic>> _items = [
  {
    'value': 'high',
    'label': 'High',
    'icon':const Icon(Icons.priority_high,color:Colors.red),
    'textStyle': const TextStyle(color: Colors.red),
  },
  {
    'value': 'medium',
    'label': 'Medium',
    'icon': const Icon(Icons.priority_high,color:Colors.yellow),
    'textStyle': const TextStyle(color: Colors.yellow),
  },
  {
    'value': 'low',
    'label': 'Low',
    'icon': const Icon(Icons.priority_high,color:Colors.blue),
    'textStyle': const TextStyle(color: Colors.blue),
  },
];
  @override
  void initState() {
    timeinput.text = ""; //set the initial value of text field
    dateinput.text="";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String dropdownValuePriority = 'high';
  final TimeOfDay _time = const TimeOfDay(hour: 11, minute: 55);
  var tasktitle="";
  var taskDesc="";
  var taskNotes="";
  late String formattedDate;
  late String formattedTime;
  late DateTime date;
  late TimeOfDay time;

  var priorityIcon = Icon(Icons.priority_high, color: accent);
  
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
              //fillColor: navColor,
              icon: Icon(Icons.title,color: accent,),
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
              //border: OutlineInputBorder(),
              icon: Icon(Icons.description,color: accent,),
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
            //  border: OutlineInputBorder(),
              icon: Icon(Icons.notes,color: accent,),
              labelText: 'Notes',
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Center(child:SelectFormField(
            type: SelectFormFieldType.dropdown, // or can be dialog
            initialValue: 'medium',
            icon: priorityIcon,
            labelText: 'Priority',
            items: _items,
            onChanged: (val) => {
              if (val=="high"){
                setState(() {
                  priorityIcon = Icon(Icons.priority_high,color: Colors.red);
                })
              }
              else if (val=="low"){
                setState(() {
                  priorityIcon = Icon(Icons.priority_high,color: Colors.blue);
                })
              }
              else{
                setState(() {
                  priorityIcon = Icon(Icons.priority_high,color: accent);
                }) 
              },

              dropdownValuePriority=val
                // print(val)
                // print(dropdownValuePriority);
            },
            onSaved: (val) => print(val),
          ),
          ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Center( 
             child:TextField(
                controller: dateinput, //editing controller of this TextField
                decoration: const InputDecoration( 
                   icon: Icon(Icons.calendar_today,color: accent,), //icon of text field
                   labelText: "Enter Date" //label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                  
                  if(pickedDate != null ){
                      date = pickedDate;
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                         dateinput.text = formattedDate; //set output date to TextField value. 
                      });
                  }else{
                      print("Date is not selected");
                  }
                },
             ),
          )
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Center( 
             child:TextField(
                controller: timeinput, //editing controller of this TextField
                decoration: const InputDecoration( 
                   icon: Icon(Icons.timer,color: accent,), //icon of text field
                   labelText: "Enter Time" //label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  
                  if(pickedTime != null ){
                      time = pickedTime;
                      print(pickedTime.format(context));   //output 10:51 PM
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      //converting to DateTime so that we can further format on different pattern.
                      print(parsedTime); //output 1970-01-01 22:53:00.000
                      formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                      print(formattedTime); //output 14:59:00
                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                      setState(() {
                        timeinput.text = formattedTime; //set the value of text field. 
                      });
                  }else{
                      print("Time is not selected");
                  }
                },
             )
          )
        ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          if (tasktitle == "") {
            return;
          }

          String pr = "";
          if (dropdownValuePriority == "high") {
            pr = "2";
          } 
          else if (dropdownValuePriority == "medium") {
            pr = "1";
          } 
          else {
            pr = "0";
          }
          String deadline;
          try {
            deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute).toString();
          }
          catch (LateInitializationError) {
            deadline = "";
          }
          Storage.AddTask(tasktitle, taskDesc, taskNotes, pr, deadline).then((v) => {Navigator.pop(this.context)});
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
