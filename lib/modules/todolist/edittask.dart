

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ghambeel/modules/todolist/todolist.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../theme.dart';
import 'package:select_form_field/select_form_field.dart';

import '../utils.dart';

class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon:  Icon(Icons.arrow_back, color: primaryText[darkMode], ),
              onPressed: () {
                  Navigator.pop(
                    context,
                  MaterialPageRoute(builder: (context) => const ToDoList(title: 'To-Do List',)),
                );
            }
            
        ),
      title:  Text('Edit Task',style: TextStyle(color: primaryText[darkMode]),),
      
      backgroundColor: bg[darkMode],
    );
  }

class EditTask extends StatefulWidget {  
  const EditTask({Key? key, required this.title, required this.task}) : super(key: key);
  final String title;
  final Task task;
  
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask>{
  //see what data type showDate/time pickers have. will need that to store it and display calendar as is
 //  this as initial valye/time 
  TextEditingController timeinput = TextEditingController(); // format and input time here from storage
  TextEditingController dateinput = TextEditingController();// format and input date here from storage
  late DateTime previousDate; // set this variable
  late TimeOfDay previousTime; // set this variable.
  //final TimeOfDay _time = const TimeOfDay(hour: 11, minute: 55); // sample how to set
  // again read existing value for priority of task.
  late String dropdownValuePriority; //rn default is high here  but also declared as initial value
  // in that part of code. have set it to inital value there. so need to change here only
  
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

    if (widget.task.priority == "0") {
      dropdownValuePriority = "low";
    }
    else if (widget.task.priority == "1") {
      dropdownValuePriority = "medium";
    }
    else {
      dropdownValuePriority = "high";
    }

    priorityIcon = Icon(Icons.priority_high, color: findColorBasedOnPriority(dropdownValuePriority));

    tasktitle = widget.task.name;
    taskDesc = widget.task.description;
    taskNotes = widget.task.notes;

    previousDate = DateTime.parse(widget.task.deadline);
    previousTime = TimeOfDay.fromDateTime(DateTime.parse(widget.task.deadline));

    dateinput.text = DateFormat('yyyy-MM-dd').format(previousDate);
    timeinput.text = DateFormat('HH:mm:ss').format(DateTime.parse(widget.task.deadline));

    //load the image
    if (widget.task.imgname != "") {
      String path = AppDirectoryPath + "/" + widget.task.imgname;
      image = File(path);

      filename = widget.task.imgname;
    }

    super.initState();
  }

  Color findColorBasedOnPriority(val){
    if (val=="high"){
      return Colors.red;
    }
    else if (val=="low"){
      return Colors.blue;
    }
    else{
      return Colors.yellow;
  }
}

  final _formKey = GlobalKey<FormState>();
  
  
  late String tasktitle=""; // this is the default value. if user does not enter value for title
  late String taskDesc="";// this is the default value. if user does not enter value for a descriptio
  late String taskNotes=""; // this is the default value. if user does not enter value for a Notes

  late var priorityIcon;
  
  File? image;
  String filename = "";
  
  Future pickImg() async {
    try{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null){
        return;
      }

      final tempImage = File(img.path);
      setState(()=>{
        image = tempImage,
        filename = tasktitle + "_" + getNowDateTime()
      });
    } 
    on PlatformException catch(e){
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
            initialValue: widget.task.name,
            decoration:  InputDecoration(
              //border: OutlineInputBorder(),
              //fillColor: navColor,
              icon: const Icon(Icons.title,color: accent,),
              labelText: "Task Title", //replacing label text with our variable'Task Title', // 
              hintText: tasktitle,
              ),
              
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskDesc=text;
            },
            initialValue: widget.task.description,
            decoration:  InputDecoration(
              //border: OutlineInputBorder(),
              icon: const Icon(Icons.description,color: accent,),
              labelText: 'Task Description', //check for input length or implemetnt check khudi where it is displayed
              hintText: taskDesc,
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
                taskNotes=text;
            },
            initialValue: widget.task.notes,
            decoration:  InputDecoration(
            //  border: OutlineInputBorder(),
              icon: const Icon(Icons.notes,color: accent,),
              labelText: 'Notes',
              hintText: taskNotes,
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Center(child:SelectFormField(
            type: SelectFormFieldType.dropdown, // or can be dialog
            initialValue:dropdownValuePriority,// 'medium',
            icon: priorityIcon,// this has yellow by default. but should have
            /// the color that isi initially in dropdown. if statement above needed
            labelText: 'Priority',
            items: _items,
            onChanged: (val) => {
              if (val=="high"){
                setState(() {
                  priorityIcon = const Icon(Icons.priority_high,color: Colors.red);
                })
              }
              else if (val=="low"){
                setState(() {
                  priorityIcon = const Icon(Icons.priority_high,color: Colors.blue);
                })
              }
              else{
                setState(() {
                  priorityIcon = const Icon(Icons.priority_high,color: accent);
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
                      context: context, 
                      initialDate: previousDate,
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                  
                  if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                      previousDate = pickedDate;
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
                          initialTime: previousTime,
                          context: context,
                      );
                  
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      //converting to DateTime so that we can further format on different pattern.
                      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                      //DateFormat() is from intl package, you can format the time on any pattern you need.
                      previousTime = TimeOfDay.fromDateTime(parsedTime);
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
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextButton(
              child: const Text("Upload image"),
              onPressed: ()=>{pickImg()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: image != null ? Image.file(image!, width:160, height:160) : const Text("No image uploaded"),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Task t = widget.task;

          t.name = tasktitle;
          t.description = taskDesc;
          t.notes = taskNotes;
          if (dropdownValuePriority == "high") {
            t.priority = "2";
          }
          else if (dropdownValuePriority == "medium") {
            t.priority = "1";
          }
          else {
            t.priority = "0";
          }

          t.deadline = DateTime(previousDate.year, previousDate.month, previousDate.day, previousTime.hour, previousTime.minute).toString().split(".")[0];
          t.imgname = filename;
          saveImg();
          Storage.EditTask(t).then((c) {
            Navigator.pop(context);
          });
          // update the form
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const addTask(title: 'Add A Task',)),
        // );
          // Add your onPressed code here! function call to creatTask
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

