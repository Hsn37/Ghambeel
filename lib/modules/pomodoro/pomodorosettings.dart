// ignore_for_file: unnecessary_const

import 'package:flutter/cupertino.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghambeel/theme.dart';
import 'package:ghambeel/modules/sharedfolder/settings.dart';
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
  var temp;
  var longbreakAfter; // validation >0 , <num of cycles. by default numofcycles/2
  var l1;//=[workingTime,shortbreaktime,longbreaktime,numOfCycles,longbreakAfter];// use this instead
  dynamic data = [];
  Widget textinput1(subtitle,whichVar,extra,ind) {
    return TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) {
                  setState(() {
                    l1[ind]=val; //corresponding variable changes value. //hoping not a copy.
                    if(ind==0){
                      Storage.setValue("cft",val.toString());
                    }
                    else if(ind==1){
                      Storage.setValue("sbt",val.toString());
                    }
                    else if(ind==2){
                      Storage.setValue("lbt",val.toString());
                    }
                    else if(ind==3){
                      Storage.setValue("cnc",val.toString());
                    }
                    else if(ind==4){
                      Storage.setValue("lba",val.toString());
                    }
                   
                  });
                    
                    print("ww");
                    print(workingTime);
                    print(l1[ind]);
                },
                decoration:  InputDecoration(
                  //border: OutlineInputBorder(),
                  //fillColor: navColor,
                // icon: Icon(Icons.title,color: accent,),
                  //labelText: 'Focus Time',
                  
                  hintText: '$subtitle $whichVar $extra'
                ),
                  
              );
  }
  Widget makeCard(String title, String subtitle, whichVar,extra,ind) {
    return Card ( //static cos otherwise implicit declaration
        elevation: 8.0,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50), ),
       // shadowColor:lightPrimary[darkMode], // const Color.fromARGB(0, 0, 255, 255),
        color: bg[darkMode],
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
        decoration: BoxDecoration(color: bg[darkMode],borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
        child: makeTile(title,subtitle,whichVar,extra,ind),
      ),
    );
  }
  Widget makeTile(String title,String subtitle,whichVar,extra,ind){
   return ListTile ( 
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.0),
      tileColor: bg[darkMode],
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50), ),
      title: Row(
        children: <Widget>[ // this needs to have task header!!!!! sample text here
          Text(title, style: TextStyle(color: primaryText[darkMode], fontSize: 16)),
          const SizedBox(width: 2,),
        ]
      ),
      subtitle: textinput1(subtitle,whichVar,extra,ind) ,

    );     
  }
   Widget makeCardFocus(String title, String subtitle) {
    return Card ( //static cos otherwise implicit declaration
        elevation: 8.0,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50), ),
        //shadowColor:lightPrimary[darkMode], // const Color.fromARGB(0, 0, 255, 255),
        color: bg[darkMode],
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
        decoration: BoxDecoration(color: bg[darkMode],borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
        child:SwitchListTile(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50), ),
              //activeColor :lightPrimary[darkMode] ,
              tileColor: bg[darkMode],
              //inactiveTrackColor: subtleGrey, // const Color.fromARGB(0, 0, 255, 255),
             //  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 25),
              subtitle: Row(
                children: <Widget>[ 
                  Text(subtitle, style: TextStyle(color: primaryText[darkMode])),
                 // const SizedBox(width:5,),
                ]
              ),
              //Text(subtitle, style: TextStyle(color: primaryText[darkMode]),),
              title:  Row(
                children: <Widget>[ 
                  Text(title, style: TextStyle(color: primaryText[darkMode], fontSize: 16)),
                  //const SizedBox(width: 5,),
                ]
              ),
              onChanged: (value){
                setState((){
                  
                  //call function to block notifications
                  //
                });
                // Navigator.pop(context);
              }, 
              value: false,
              
            ),             
      ),
    );
  }

  Future<dynamic> getAllData() async {
  // this function gets data for all charts. you can do more processing here if you want.
  // bar and heatmap data should be fine as is. pie data you'll have to deal with dynamically. it
  // has top 5 or less.

      temp=await Storage.getValue("cft") ;///load from memory
      workingTime=int.parse(temp);
      temp=await Storage.getValue("sbt"); //load from memory
      shortbreaktime=int.parse(temp);
      temp= await Storage.getValue("lbt"); // load from memory
      longbreaktime=int.parse(temp);
      temp=await Storage.getValue("cnc"); // load from memory
      numOfCycles=int.parse(temp);
      temp= await Storage.getValue("lba"); //load from memory
      longbreakAfter=  int.parse(temp);

    return [workingTime, shortbreaktime, longbreaktime,numOfCycles,longbreakAfter];
  }

  @override
  void initState() async{
      
      l1=[workingTime,shortbreaktime,longbreaktime,numOfCycles,longbreakAfter]; // load from memory at these positions or no need here
  }

  @override
  Widget build(BuildContext context) {
    // darkMode = isDark ? 1 : 0;
    return
      FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot) {
            
            if (snapshot.connectionState == ConnectionState.done) {
              data = snapshot.data;
               return Scaffold(
                  appBar: topBar(context:context, myTitle: '', ),
                  body:SafeArea(

                    child:Container(
                    child:ListView(
                      
                      padding: EdgeInsets.all(24),
                      children: [
                        // const Padding(
                        //     padding: EdgeInsets.all(24),
                        //     child:  Text("Improve Focus",style: TextStyle(color: subtleGrey )),
                        // ),
                        //  makeCardFocus("Focus Mode", "Turn On to Block Notifications While Working"),
                        const Padding(
                            padding: const EdgeInsets.all(24),
                            child:  Text("Edit The Pomodoro Cycle Preferences",style: TextStyle(color: subtleGrey ,fontSize: 16)),

                        ),
                        makeCard("Focus Time", "Current Focus Time ", workingTime,'',0),  
                        makeCard("Short Break", "Short Break Duration ",shortbreaktime,'',1),
                        makeCard("Long Break", "Long Break Duration ",longbreaktime,'',2),
                        makeCard("Number of Cycles", "Current Number of Cycles ", numOfCycles,'',3),
                        makeCard("Schedule Long Break", "Long Break is after ", longbreakAfter, 'cycles',4),
                      ],
                  ) 
                ),
                ),
                );

            
            }else{
               return const CircularProgressIndicator();
            }
        }

       
    );


   
  }
}