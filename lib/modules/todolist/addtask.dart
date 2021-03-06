import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../theme.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';
// import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
//import 'package:smart_select/smart_select.dart';
// import 'package:flutter_awesome_select/flutter_awesome_select.dart';


class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryText[darkMode], ),
              onPressed: () {
                var currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => const ToDoList(title: 'To-Do List',)),
                );

            }
            
        ),
      title: Text('Add A Task',style: TextStyle(color: primaryText[darkMode]),),
      
      backgroundColor: bg[darkMode],
    );
  }

class AddTask extends StatefulWidget {  
  const AddTask({Key? key, required this.title, this.deadlineMust = false}) : super(key: key);
  final String title;
  final bool deadlineMust;
  @override
  _AddTaskState createState() => _AddTaskState();
}

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

  Future pickImg() async {
    try{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null){
        return;
    }

    final tempImage = File(img.path);
    setState(()=>{
      image = tempImage,
      filename = (tasktitle + "_" + getNowDateTime()).replaceAll(" ", "")
    });} on PlatformException catch(e){
      print("Permission denied");
    }
  }

  Future saveImg() async {
    if (image!= null) {
      String path = AppDirectoryPath;
      final File? localImage = await image?.copy('$path/$filename');
      print('$path/$filename');
    }
  }

  final _formKey = GlobalKey<FormState>();
  String dropdownValuePriority = 'medium';
  final TimeOfDay _time = const TimeOfDay(hour: 11, minute: 55);
  var tasktitle="";
  var taskDesc="";
  var taskNotes="";
  File? image;
  String filename = "";
  late String formattedDate;
  late String formattedTime;
  late DateTime date;
  late TimeOfDay time;
  
  bool dateChosen = false;
  bool timeChosen = false;
  /*
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
  //DateTime _date= DateTime(2022,1,1);
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
*/

  var priorityIcon = Icon(Icons.priority_high, color: accent);
  
  Widget imageDisplay() {
    return Column (
      children: [
        Image.file(image!, width:160, height:160),
        IconButton(onPressed: () => {setState(() {image = null; filename = "";})}, icon: const Icon(Icons.delete, size: 28, color: Colors.red,))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: bg[darkMode],
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
            decoration: InputDecoration(
              icon: Icon(Icons.title, color: accent,),
              enabledBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: primaryText[darkMode]),   
                ), 
                labelText: "Task Title",
                labelStyle: TextStyle(color: primaryText[darkMode]),
              ),
              style: TextStyle(color: primaryText[darkMode]),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskDesc=text;
            },
            decoration: InputDecoration(
              //border: OutlineInputBorder(),
              icon: Icon(Icons.description,color: accent,),
              enabledBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: primaryText[darkMode]),   
                ), 
                labelText: "Task Description",
                labelStyle: TextStyle(color: primaryText[darkMode]),
              ),
              style: TextStyle(color: primaryText[darkMode]),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskNotes=text;
            },
            decoration: InputDecoration(
            //  border: OutlineInputBorder(),
              icon: Icon(Icons.notes,color: accent,),
              enabledBorder: UnderlineInputBorder(      
                  borderSide: BorderSide(color: primaryText[darkMode]),   
                ), 
                labelText: "Notes",
                labelStyle: TextStyle(color: primaryText[darkMode]),
              ),
              style: TextStyle(color: primaryText[darkMode]),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Center(
              child:SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: 'medium',
                style: TextStyle(color: primaryText[darkMode]),
                decoration: InputDecoration(
                    icon: priorityIcon,
                    enabledBorder: UnderlineInputBorder(      
                    borderSide: BorderSide(color: primaryText[darkMode]),   
                  ), 
                  labelText: "Priority",
                  labelStyle: TextStyle(color: primaryText[darkMode]),
                ),
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
                style: TextStyle(color: primaryText[darkMode]),
                decoration: InputDecoration( 
                   icon: Icon(Icons.calendar_today,color: accent,), //icon of text field
                   labelText: "Enter Date", //label text of field
                   labelStyle: TextStyle(color: primaryText[darkMode]),
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                  
                  if(pickedDate != null ){
                      dateChosen = true;
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
                style: TextStyle(color: primaryText[darkMode]),
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer,color: accent,), //icon of text field
                   labelText: "Enter Time", //label text of field
                   labelStyle: TextStyle(color: primaryText[darkMode]),
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  
                  if(pickedTime != null ){
                      timeChosen = true;
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
                  }
                  else{
                      print("Time is not selected");
                  }
                },
             )
          )
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextButton(
              child: const Text("Upload image"),
              onPressed: ()=>{pickImg()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: image != null ? imageDisplay() : Text("No image uploaded", style: TextStyle(color: primaryText[darkMode])),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          if (tasktitle == "") {
            alertDialog("Error", "You must add a title.", context);
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
            deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute).toString().split(".")[0];
          }
          catch (e) {
            if (widget.deadlineMust) {
              alertDialog("Error", "You must add a deadline for this task as you are adding via calendar", context);
              return;
            }

            if ((dateChosen && !timeChosen) || (!dateChosen && timeChosen)) {
              alertDialog("Error", "You must choose both a date and time", context);
              return;
            }
            
            deadline = "";
          }

          Storage.AddTask(tasktitle, taskDesc, taskNotes, pr, deadline, filename).then((v) => {Navigator.pop(this.context)});
          saveImg();
          print(filename);
        },
        backgroundColor: toDoIconCols,//Colors.teal.shade800,
        focusColor: Colors.blue,
        foregroundColor: bg[darkMode], //Colors.amber,
        hoverColor: accent,
        child: const Icon(Icons.check),
        
      ),
    );
  }
}

