// ignore_for_file: unnecessary_const

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghambeel/theme.dart';

//import 'package:flutter_settings_screens/flutter_settings_screens.dart';


class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryText[darkMode], ),           
              onPressed: () {
                  Navigator.pop(
                    context,
                );
            }
            
        ),
      title:  Text('Pomodoro Settings',style: TextStyle(color: primaryText[darkMode]) ,),
      
      backgroundColor: bg[darkMode], //
    );
  }


class PomodoroSettings extends StatefulWidget {

  @override
  _Pomodorosettings createState() => _Pomodorosettings();

}


class _Pomodorosettings extends State<PomodoroSettings> {
  var workingTime; // set app default time 25
  var shortbreaktime; // set app default time 5
  var longbreaktime; // set app default time double of shortbreaktime.
  var numOfCycles;
  var longbreakAfter; // validation >0 , <num of cycles. by default numofcycles/2
  Widget textinput1() {
    return TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) {
                    workingTime=val;
                },
                decoration:  InputDecoration(
                  //border: OutlineInputBorder(),
                  //fillColor: navColor,
                // icon: Icon(Icons.title,color: accent,),
                  //labelText: 'Focus Time',
                  hintText: 'Focus Time is $workingTime'
                ),
                  
              );
  }
  @override
  void initState(){
      workingTime=25;
      shortbreaktime=5;
      longbreaktime=10;
      numOfCycles=4;
      longbreakAfter=numOfCycles/2;
  }
  @override
  Widget build(BuildContext context) {
    // darkMode = isDark ? 1 : 0;
    return Scaffold(
      appBar: topBar(context:context, myTitle: '', ),
      body:SafeArea(
        child:ListView(
          
          padding: EdgeInsets.all(24),
          children: [
            const Text("Edit The preferences below"),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) {
                    workingTime=val;
                },
                decoration:  InputDecoration(
                  //border: OutlineInputBorder(),
                  //fillColor: navColor,
                // icon: Icon(Icons.title,color: accent,),
                  //labelText: 'Focus Time',
                  hintText: 'Focus Time is $workingTime'
                ),
                  
              ),
            ),  
            ListTile( 
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
              leading: Container(
              decoration: const BoxDecoration(
                border:  Border(
                  right:  BorderSide(width: 1.0, color: toDoIconCols)),
              ),
              child: Text("Focus Time:"),
                
                constraints: const BoxConstraints(),
              ),
              title: Row(
                children: <Widget>[ // this needs to have task header!!!!! sample text here
                  Text("Focus Time", style: TextStyle(color: primaryText[darkMode], fontSize: 18)),
                  const SizedBox(width: 2,),
                ]
              ),
              subtitle: textinput1() ,

            ),        
          ],
        ) 
      ),
      
      
    );
  }
}