import 'dart:async';
import 'dart:html';
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
                );
            }
            
        ),
      title: const Text('Pomodoro Timer',style: TextStyle(color: primaryText),),
      actions: [
        IconButton(
            icon: const Icon(Icons.settings),
            color: accent,
            tooltip: 'Open Pomodoro Settings',
            onPressed: () {
              // handle the press leads to settings page prefilled with default. 
              //store these settings even if app closes.
            },
          ),

      ],
      backgroundColor: bg,
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
  late final currentCycleNumber;
  static const testDuration = Duration(minutes:  00, seconds: 10);//load from storage
  static const shortBreakDuration = Duration(minutes:  0, seconds: 3);//load from storage
  static const longBreakDuration = Duration(minutes:  0, seconds: 40);//load from storage
  Duration myTime = const Duration();
  Timer? timer;
  var isStopState=1;
  var selectedAssignment="USA";// select default assignment here.
  var timerTypeList=["Focus Time","Short Break","Long Break","None"];
  var timerType;
  var temp1;
  var longBreakAfter=2;
  var numOfCycles=4; // load number of cyeces from storage by default set in settings
  var currentCycleNum;
 // long break activated if numofcycles mod longbreakafter==0. call long break.

  bool breakOrFocus(){
    if (timerType=="Short Break"|| timerType=="Long Break"){
      return false;
    }
    else{
      return true;
    }
  }
  void resetTimerFocus(){
    timerType=timerTypeList[0]; 
    myTime=testDuration;
    setState(() {
      createTimer();
    });
    
  }

  void startTimer(duration) {
    myTime = duration;
    
    timer = Timer.periodic(const Duration(seconds: 1), (_){addTime();});
  }

  void stopTimer(isRunning) {
    if (isRunning) {
      timer?.cancel();
      setState(() {
        if (breakOrFocus()){
          //record the study time
          currentCycleNumber=currentCycleNum-(currentCycleNum-1);
          //initState();
          //record data in storage
          resetTimerFocus();
          setState(() {
            createTimer();
          });
          print("snjndbsn amm hereeee!!!!!");

        }
        else{
          print("break time not recorded for assgignment.");
          // break ending early reset timer
          currentCycleNumber+=1;
          resetTimerFocus();
          
         } //
      });
    }
  }
  void setBreakTimer(){
    myTime=shortBreakDuration;
    timerType=timerTypeList[1];
   // startTimer(shortBreakDuration); //recheck
   setState(() {
     createTimer();
   });
    
  }
  void stopTimerAuto(){
    timer?.cancel();
    if (breakOrFocus()==true){
      //focus time was active
      //activate break time.
      
      setBreakTimer();
    }
    else{
     
      currentCycleNumber+=1;// break ended so next cycle number
      resetTimerFocus();
    }
    // else{
    //   if()
    // }
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
  Widget createTimer() {
    String formatted(int n) => n.toString().padLeft(2, "0") ;
    String minutes = formatted(myTime.inMinutes.remainder(60));
    String seconds = formatted(myTime.inSeconds.remainder(60));
    final isRunning = timer == null ? false : timer!.isActive;
    
   
    
    return Container(
      padding:const EdgeInsets.all(50.0) ,
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
                      value: myTime.inSeconds / testDuration.inSeconds,
                      valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
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
          isRunning
          ?Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(
              //   child:(isPaused>0) ?
                ElevatedButton(
                  style: ElevatedButton.styleFrom(onSurface: Colors.blue),
                  onPressed: isButtonResumeActive ? (){
                      setState(() {
                      isPaused=2; 
                      isButtonResumeActive=false;

                      });  
                  }:null, 
                  child: const Text("Resume")
                ),
             //    :
                ElevatedButton(
                onPressed: (isPaused>0)? (){
                  setState(() {
                    isPaused=0; 
                    isButtonResumeActive=true;
                    });
                  }:null, 
                  child: const Text("pause") 
                ),
              ElevatedButton(
                onPressed: (){
                  isStopState=1;
                  stopTimer(isRunning);
                },
                child:  const Text("Stop"),
              ),
            ],
          )
          :Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                    onPressed: (){
                      if(timerType==timerTypeList[0]){
                        startTimer(testDuration);
                      }else{
                        startTimer(shortBreakDuration);
                      }
                      
                      isStopState=0;
                      isPaused=2;
                    },
                    child: const Text("Start"),
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
          const Text('You are currently working on: '),
          const SizedBox( height: 10, ),
          DropdownButton(
              items:currentTaskList,
              value:selectedAssignment,
              iconDisabledColor: accent,
              hint: const Text("Select Task"),
              disabledHint: Text(selectedAssignment),
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
          createTimer(),
        
          
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