import 'dart:async';
import 'package:pausable_timer/pausable_timer.dart';

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
import 'pomodorosettings.dart';


class topBar extends AppBar {
    final String myTitle;
    topBar({Key? key, required BuildContext context,required this.myTitle})
    : super(
        key: key,
        leading: IconButton(
              icon:  Icon(Icons.arrow_back,color: primaryText[darkMode],  ),           
              onPressed: () {
                  Navigator.pop(
                    context,
                );
            }
            
        ),
      title: Text('Pomodoro Timer',style: TextStyle(color: primaryText[darkMode]),),
      actions: [
        IconButton(
            icon: Icon(Icons.settings),
            color: primaryText[darkMode],
            tooltip: 'Open Pomodoro Settings',
         
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PomodoroSettings())),

              // handle the press leads to settings page prefilled with default. 
              //store these settings even if app closes.
 
          ),

      ],
      backgroundColor: bg[darkMode],
    );
  }

class PomodoroTimer extends StatefulWidget{
  const PomodoroTimer({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  PomodoroTimerState createState() => PomodoroTimerState();
}

class PomodoroTimerState extends State<PomodoroTimer>{
  final _formKey = GlobalKey<FormState>();
  late final List<DropdownMenuItem<String>> currentTaskList; // populate in init 
  var currentCycleNumber;
  static const testDuration = Duration(minutes:  00, seconds: 10);//load from storage
  static const shortBreakDuration = Duration(minutes:  0, seconds: 3);//load from storage
  static const longBreakDuration = Duration(minutes:  0, seconds: 5);//load from storage
  Duration myTime = const Duration();
  Timer? timer;
  var isStopState=1;
  var selectedAssignment="USA";// select default assignment here.
  var timerTypeList=["Focus Time","Short Break","Long Break","None"];
  var timerType;
  var temp1;
  var longBreakAfter=2;
  var numOfCycles=4; // load number of cyeces from storage by default set in settings
 
 // long break activated if numofcycles mod longbreakafter==0. call long break.

  bool breakOrFocus(){
    if (timerType==timerTypeList[1]|| timerType==timerTypeList[2]){
      return false;
    }
    else{
      return true;
    }
  }
  void resetTimerFocus(){
    setState(() {
      timerType=timerTypeList[0];
      myTime=testDuration;
      createTimer(testDuration);
    });    
  }

  void startTimer(duration) {
    myTime = duration;
    timer = Timer.periodic(const Duration(seconds: 1), (_){addTime();});
  }

  void stopTimer(isRunning) {
    if (isRunning) {
      timer?.cancel();
     
        if (breakOrFocus()){
          //record the study time
          setState(() {
             currentCycleNumber=currentCycleNumber-(currentCycleNumber-1);
          });
         // 
          //initState();
          //record data in storage
          resetTimerFocus();
         // setState(() {
         //   createTimer();
         // });
          print("snjndbsn amm hereeee!!!!!");

        }
        else{
          print("break time not recorded for assgignment.");
          // break ending early reset timer
          setState(() {
             currentCycleNumber+=1;
          });
         
          resetTimerFocus();
          
         } //
      
    }
  }
  void setLongBreakTimer(){
    
     setState(() {
       timerType=timerTypeList[2];
       if (longBreakDuration>testDuration){
         myTime=testDuration;
         createTimer(testDuration);
       }
       else{
          myTime=longBreakDuration;
          createTimer(longBreakDuration);
       }
      
      
    });
  }
  void setBreakTimer(){
    setState(() {
      myTime=shortBreakDuration;
      timerType=timerTypeList[1];
      createTimer(shortBreakDuration);
    });
    
   // startTimer(shortBreakDuration); //recheck
   //setState(() {
    // createTimer();
   //});
    
  }
  void pauseTimer(typeofduration) {
    if (timer != null){ 
      var elapsedtime= typeofduration-myTime;
      timer?.cancel();    
    }

  }
  void resumeTimer() {
    startTimer(myTime);
  } 

  void stopTimerAuto(){
    timer?.cancel();
    if (breakOrFocus()==true){
      //focus time was active
      //activate break time.
      print("am in focus stop timer auto, ");
      print(currentCycleNumber);
      print(longBreakAfter);
      if (currentCycleNumber%longBreakAfter ==0){
       
        setLongBreakTimer();
      }
      else{
        print("short call");
        print(longBreakAfter % currentCycleNumber);
        setBreakTimer();
      }
      
    }
    else{
      print("am in break stop timer auto");
      setState(() {
        currentCycleNumber=currentCycleNumber+ 1;
      });
      // break ended so next cycle number
      resetTimerFocus();
    }
    
  }

  void addTime() {
    final newTime = myTime.inSeconds - 1;

    if (newTime < 0) {
      stopTimerAuto();
    }
    else {
      setState(() {
        myTime = Duration(seconds: newTime);
      });
    }
  }
  
  _loadCurrentTaskList(){//load assignment list. use index for vallue and display title as text
     currentTaskList = [
       DropdownMenuItem(child: Text("USA"),value: "USA"),
       DropdownMenuItem(child: Text("Canada"),value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
     ];
                               
    //
  }
  Widget _buildPopupDialog(BuildContext context, String contents) {
  return  AlertDialog(
    title: const Text('Popup example'),
    content:  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(contents),
      ],
    ),
    actions: <Widget>[
       TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}

  var allowSelectionOnce=0;
  @override
  void initState() {
      pausedwithrunning=false;
      super.initState();
      currentCycleNumber=1;
      _loadCurrentTaskList();
      allowSelectionOnce=0;
      timerType=timerTypeList[0];
      myTime=testDuration;
      //currentcyclenum=0;
  }
  void do_nothing(){

  }
  var pausedwithrunning;
  var isPaused=0;
  var isButtonResumeActive = false;
  bool checkVisibilityStatus(){
    if (allowSelectionOnce>0){
      return true;
    }
    else{
      return false;
    }
  }
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    //onPrimary: lightPrimary[darkMode],

    primary: lightPrimary[darkMode],

   // minimumSize: const Size(250, 100),
    //padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
  final TextStyle myTextStyle = TextStyle(
    color: primaryText[darkMode],
  );
  Widget createTimer(typeofduration) {
    String formatted(int n) => n.toString().padLeft(2, "0") ;
    String minutes = formatted(myTime.inMinutes.remainder(60));
    String seconds = formatted(myTime.inSeconds.remainder(60));
    var isRunning = timer == null ? false : timer!.isActive;
    
    
    return Container(
      padding:const EdgeInsets.all(20.0) ,
      child: Visibility(
        visible: checkVisibilityStatus(),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height:200,
                    child: CircularProgressIndicator(
                      value: myTime.inSeconds / typeofduration.inSeconds,
                      valueColor:  AlwaysStoppedAnimation(lightPrimary[darkMode]),
                      strokeWidth: 16,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
                
                Column(
                  children: [
                        const SizedBox(height: 45),
                          Center(       
                            child:Text(
                                  '$minutes:$seconds',
                                  style: const TextStyle(fontSize: 60),
                            ),
                          ),
                          Center(
                            child:Text(timerType,style: const TextStyle(fontSize: 15),)
                            
                          )
                  ],
                )
              ],
            ),
          ),
           SizedBox(
             height: 10,
             ),
          //   child:
          Row(
             mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Text('Cycle $currentCycleNumber of $numOfCycles')
              ],
            ),
          // ),
          SizedBox(height:20),
          (isRunning || pausedwithrunning)
          ?Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(
              //   child:(isPaused>0) ?
                ElevatedButton(
                 style: raisedButtonStyle,
                  onPressed: isButtonResumeActive ? (){
                      setState(() {
                      isPaused=2; 
                      isButtonResumeActive=false;
                      pausedwithrunning=false;
                      resumeTimer();
                    });  
                  }:null, 
                  child:  Text("Resume",style: myTextStyle,)
                ),
             //    :
                ElevatedButton(
                  style: raisedButtonStyle,
                onPressed: (isPaused>0)? (){
                  setState(() {
                    isPaused=0; 
                    isButtonResumeActive=true;
                    pauseTimer(typeofduration);
                    //isRunning=true;
                    pausedwithrunning=true;
                    });
                  }:null, 
                  child: Text("pause",style: myTextStyle,) 
                ),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: (){
                  setState(() {
                    if (timerType==timerTypeList[0]){
                        isStopState=1;
                    }
                    pausedwithrunning=false;
                    
                  });
                  stopTimer(isRunning);
                },
                child: Text("Stop",style: myTextStyle,),
              ),
            ],
          )
          :Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: raisedButtonStyle,
                    onPressed: (){
                      if(timerType==timerTypeList[0]){
                        startTimer(testDuration);
                      }else{
                        startTimer(shortBreakDuration);
                      }
                      setState(() {
                        isStopState=0;
                        isPaused=2;
                      });
                      
                    },
                    child: Text("Start",style: myTextStyle,),
              ),    
            ]
          ),
        ],
      
      
      ),
    
      ),
    );
  }

  Widget makeBody() {
    var flag1=false;
    return SafeArea(
      child: Center(
        child: Column(
          children:[
          const SizedBox(
                height: 10,
            ),
          Text('You are currently working on: ',style: TextStyle(color:(allowSelectionOnce>1)? subtleGrey:primaryText[darkMode] )  ),
          const SizedBox( height: 10, ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              iconEnabledColor: lightPrimary[darkMode],
              items:currentTaskList,
              value:selectedAssignment,
              iconDisabledColor: subtleGrey,
              hint: Text("Select Task",style: TextStyle(color: subtleGrey),),
              disabledHint: Text(selectedAssignment,style: TextStyle(color: subtleGrey),),
               onChanged: (allowSelectionOnce<1) ? (String ?nvalue)
               { 
                 setState(() 
                    {
                      selectedAssignment = nvalue!;
                      allowSelectionOnce+=2;
                      flag1=true;
                    }
                 );
               } : null,
          ),
          ),
          
          createTimer(testDuration),
        
          
          // SelectFormField(
          //   type: SelectFormFieldType.dropdown , // or can be dialog
          //   initialValue: 'medium',
          //   labelText: 'Priority',
          //  // items: currentTaskList,
          //   onChanged: (val)=>
          //   {
          //     if (allowSelectionOnce>0){
          //       _buildPopupDialog(context, "Task already running. Exit current timer to change assignment")
          //     }
          //     else{
          //         allowSelectionOnce=1
          //     }


          //   },
          // )
          

          ],
        )
      ),
      
      


    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: (isStopState>0)? topBar(context: context, myTitle: '',):null,
      key: _formKey,
      body: makeBody(),
    );
  }

}