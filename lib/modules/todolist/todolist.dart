// ignore_for_file: unnecessary_const, deprecated_member_use, curly_braces_in_flow_control_structures
import 'dart:async';

import 'package:ghambeel/modules/storage/storage.dart';
import 'package:ghambeel/modules/todolist/addtask.dart';
import 'package:ghambeel/modules/todolist/edittask.dart';
import 'package:ghambeel/modules/todolist/filter.dart';
import 'package:ghambeel/modules/todolist/viewtasks.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import '../../theme.dart';

class ToDoList extends StatefulWidget{
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;
  // static final topBar = AppBar(
  //   leading: const Icon( Icons.menu, color: primaryText[darkMode]),
  //   title: const Text('To- Do List',style:TextStyle(color: primaryText[darkMode])),
  //   backgroundColor: bg[darkMode],
  // );

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ToDoList>{
  
  int presentComp = 0;
  int perPageComp = 3;
  int presentUncomp = 0;
  int perPageUncomp = 3;

  // 3 corresponds to "None" in the list;
  int currentFilter = 3;

  var completedTasks = <Task>[];
  var incompleteTasks = <Task>[];

  var itemsComp = <Task>[];
  var itemsUncomp = <Task>[];

  var fetchData = true;
  
  @override
  void initState() {
      super.initState();
    }
  void loadMoreComp() {
      setState(() {
        if((presentComp + perPageComp )> completedTasks.length) {
          itemsComp.addAll(
              completedTasks.getRange(presentComp, completedTasks.length));
        } else {
          itemsComp.addAll(
              completedTasks.getRange(presentComp, presentComp + perPageComp));
        }
        presentComp = presentComp + perPageComp;
      });
    
  }
  void loadMoreUncomp() {
      setState(() {
        if((presentUncomp + perPageUncomp )> incompleteTasks.length) {
          itemsUncomp.addAll(
              incompleteTasks.getRange(presentUncomp, incompleteTasks.length));
        } else {
          itemsUncomp.addAll(
              incompleteTasks.getRange(presentUncomp, presentUncomp + perPageUncomp));
        }
        presentUncomp = presentUncomp + perPageUncomp;
      });
    
  }
  Widget makeBody(BuildContext context){

    return ListView (
      //shrinkWrap: true,
      //physics: const ClampingScrollPhysics(), 
      children:<Widget>[
        Container(
          color: bg[darkMode],
          //mainAxisAlignment: MainAxisAlignment.start
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child:Column(
            children: [
              Row(             
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text("Incomplete: ${incompleteTasks.length}, Complete: ${completedTasks.length}", style: TextStyle(fontSize: 12,color: primaryText[darkMode])),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child:  IconButton(
                      icon: Icon(Icons.filter_list, color: toDoIconCols),
                      onPressed: () {
                        filterTasks(context, currentFilter).then((val) {
                          if (val != null && val != -1) {
                            print(val);
                            currentFilter = val;
                            setState(() {
                              fetchData = true;
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Incomplete",style: TextStyle( fontWeight: FontWeight. bold,fontSize: 14,color: primaryText[darkMode])),
                    ),
                  ],
              ),            
          ],
          )        
        ),  
        Container(
            decoration: BoxDecoration(color:bg[darkMode]),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child:ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              // itemCount: 5, // number here shold be the sum of items in to do list
                itemCount: (presentUncomp <= incompleteTasks.length) ? itemsUncomp.length + 1 : itemsUncomp.length,
                itemBuilder: (context, index) {
                  return (index == itemsUncomp.length) ?
                    Container(
                      color: lightPrimary[darkMode].withOpacity(0.1),
                      child: TextButton(
                          child: Opacity(
                            opacity: 0.3,
                            child: Text("More incomplteed tasks",style: TextStyle(color: primaryText[darkMode])),
                          ),
                        // child: const Text("Load More",style: TextStyle(color: Colors.black.withOpacity(0.5))
                        onPressed: () {
                          loadMoreUncomp();
                        },
                      ),
                    )
                        :
                        makeCardundone(index);
                    // ListTile(
                    //   title: Text(items[index]),
                    // );
                  },
          
                //itemBuilder: (BuildContext context, int index) {
                  // make card creates the items. receive data from make card for our tasks
              ),
        ),

        Container(
          //mainAxisAlignment: MainAxisAlignment.start
          color: bg[darkMode],
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child:Column(
            children: [
              Row(
                children:  [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Complete",style: TextStyle( fontWeight: FontWeight. bold,fontSize: 14,color: primaryText[darkMode])),
                    ),
                  ],
              ),            
          ],
          )        
        ),
        Container(
            decoration: BoxDecoration(color:bg[darkMode]),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child:ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              // itemCount: 5, // number here shold be the sum of items in to do list
                itemCount: (presentComp <= completedTasks.length) ? itemsComp.length + 1 : itemsComp.length,
                itemBuilder: (context, index) {
                  return (index == itemsComp.length) ?
                    Container(
                      color: lightPrimary[darkMode].withOpacity(0.1),
                      child: TextButton(
                      child:  Opacity(
                            opacity: 0.3,
                            child: Text("More completed tasks",style: TextStyle(color: primaryText[darkMode])),
                      ),
                        onPressed: () {
                          loadMoreComp();
                        },
                      ),
                    )
                        :
                        makeCarddone(index);
                  },          
              ),
        ),
    ]    
  );
  }
  Widget makeCarddone(int index) {
    return Card ( //static cos otherwise implicit declaration
      elevation: 8.0,
      shadowColor: const Color.fromARGB(0, 0, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: BoxDecoration(color: bg[darkMode],borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
      child: makeListTile(index, itemsComp),
    ),
  );
}
  Widget makeCardundone(int index){
    return Card ( //static cos otherwise implicit declaration
      elevation: 8.0,
      shadowColor: Color.fromARGB(0, 0, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shape: const RoundedRectangleBorder(borderRadius:  const BorderRadius.all(Radius.circular(25))),
      child: Container(
      decoration:  BoxDecoration(color: bg[darkMode]),// function call check task urgency, select and return color!!!
      child: makeListTileUncomp(index, itemsUncomp),
    ),
  );
}
  Widget makeListTileUncomp(int index, List<Task> list) {
    
    Color timerCol;
    if (list[index].priority == "0")
      timerCol = Colors.blue;
    else if (list[index].priority == "1")
      timerCol = accent;
    else
      timerCol = Colors.red;

    return ListTile( 
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
      dense: true, //assuming task title+description so keeping it true, check with false once text here
      enabled: true, //keep this false when task is completed so that object is not interactive. cant edit if task done from to do list.
      shape: const RoundedRectangleBorder(borderRadius:  const BorderRadius.all(Radius.circular(25))),
      leading: Container(
          decoration: const BoxDecoration(
            border: const Border(
              right: const BorderSide(width: 1.0, color: toDoIconCols)),
          ),
          child: IconButton(
            icon: Icon(Icons.check_box_outline_blank_outlined,color: toDoIconCols),
            onPressed: () {
              Storage.markTaskDone(list[index]).then((v) {
                setState(() {
                  fetchData = true;
                });
              });
            },
            constraints: const BoxConstraints(),
           ),
        ),
      title: Row(
          children: <Widget>[ // this needs to have task header!!!!! sample text here
            Text(shortenTitle(list[index].name), style: TextStyle(color: primaryText[darkMode], fontSize: 18)),
            const SizedBox(width: 2,),
            Icon(Icons.timer, color: timerCol, size: 14)
          ]
        ),
      subtitle: Text(shortenDescription(list[index].description), style: TextStyle(color: secondaryText[darkMode])),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton (
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20.0),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () => Storage.deleteTask(list[index]).then((T) => {
                setState(() {
                  fetchData = true;
                })
              }),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.green[300], size: 20.0),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditTask(title: 'Edit Task', task: list[index])),
              ).then((T) => {
                setState(() {
                  fetchData = true;
                })
              }),
          ),
        ]
      ),
      onTap: () => viewTask(list[index], context),
    );
  }

  String shortenTitle(String x){
    int stringLength = 12;

    if (x.length > stringLength) {
      return x.substring(0, stringLength) + "...";
    }
    else {
      return x;
    }
  }
  String shortenDescription(String x){
    int stringLength = 25;

    if (x.length > stringLength) {
      return x.substring(0, stringLength) + "...";
    }
    else {
      return x;
    }
  }
  
  // see options for this.
  Widget makeListTile(int index, List<Task> list){

    Color timerCol;
    if (list[index].priority == "0")
      timerCol = Colors.blue;
    else if (list[index].priority == "1")
      timerCol = accent;
    else
      timerCol = Colors.red;

    return ListTile( 
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      // tileColor: const Color.fromARGB(199, 152, 182, 17),
      // shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(100.0))),
      dense: true, //assuming task title+description so keeping it true, check with false once text here
      enabled: true, //keep this false when task is completed so that object is not interactive. cant edit if task done from to do list.
      leading: Container(
          decoration: const BoxDecoration(
          border: const Border(
                  right: const BorderSide(width: 1.0,color:toDoIconCols)),
                  ),
          child: IconButton(
            icon: Icon(Icons.check_box, color: toDoIconCols),
            onPressed: () {
              Storage.markTaskunDone(list[index]).then((v) {
                setState(() {
                  fetchData = true;
                });
              });
            },
            constraints: BoxConstraints(),
            // decoration: IconDecoration(
            //   shadows: [Shadow(blurRadius: 2, offset: Offset(0,0))],
            //   gradient: LinearGradient(colors:[Color.fromARGB(255, 155, 17, 17),Color.fromARGB(255, 12, 10, 10)] )
            // ),
            ),
          ),
        title: Text( // this needs to have task header!!!!! sample text here
            list[index].name,
            style: TextStyle(color:primaryText[darkMode],  fontSize: 18),
          ),
        subtitle: Row(
            children: <Widget>[
              Text(shortenDescription(list[index].description), style:  TextStyle(color: secondaryText[darkMode])),
            // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
              // so set color thru a function??
            ],
          ),
        trailing: Icon(Icons.timer, color: timerCol, size: 20.0), // not required as per our interface, or we can put that tmer here
          // we can set color of this timer from red yellow to blue based on task importance? 
        onTap: () => print(index.toString() + "pressed"),
      
    );
  } 

  void sortTasks() {
    if (currentFilter == 1) {
      // sort by deadlines
    }
    else if (currentFilter == 2) {
      // sort by priorities
    }
    else if (currentFilter == 3) {
      // do nothing. this is the "None option"
    }
  }

  @override
  Widget build(BuildContext context){
    if (fetchData) {
      var start = DateTime.now();
      Storage.fetchTasks().then((v) => {
        // Reset these with every refresh
        itemsUncomp = <Task>[],
        itemsComp = <Task>[],
        presentComp = 0,
        presentUncomp = 0,

        incompleteTasks = Task.parseTasks(v["incomplete"]), 
        completedTasks = Task.parseTasks(v["complete"]),

        // sorts the tasks based on the filter selected. by default, none is selected.
        sortTasks(),

        // makes sure the loading screen is displayed for 1 second.
        // calculates the remaining time from 1 second that is left, after loading the data.
        // and sets the timeout for that much time.
        Timer(Duration(milliseconds: 1000 - DateTime.now().difference(start).inMilliseconds), () => setState(() => {
          fetchData = false,
          loadMoreComp(),
          loadMoreUncomp()
        })),
      });

      return Loading();
    }
    else {
      return Scaffold (
      //appBar: ToDoList.topBar,
      backgroundColor: bg[darkMode],
      body:makeBody(context),
      floatingActionButton: FloatingActionButton(
        //splashColor: plusFloatCol,
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTask(title: 'Add A Task')),
        ).then((T) => {
          setState(() {
            fetchData = true;
          })
        });
          // Add your onPressed code here! function call to creatTask
        },
        backgroundColor: toDoIconCols,//Colors.teal.shade800,
        focusColor: Colors.blue,
        foregroundColor: bg[darkMode], //Colors.amber,
        hoverColor: accent, //Colors.green,
        //splashColor: Colors.tealAccent,

        child: const Icon(Icons.add ),
      ),
    ); 
    }
  }
}
