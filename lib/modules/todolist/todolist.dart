// ignore_for_file: unnecessary_const, deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:ghambeel/modules/todolist/addtask.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import '../../theme.dart';
// class ListPage extends StatefulWidget {
//   ListPage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _ListPageState createState() => _ListPageState();
// }

// class _ListPageState extends State<ListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//       appBar: topAppBar,
     
//     );
//   }
// }

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


class ToDoList extends StatefulWidget{
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;
  static final topBar = AppBar(
    leading: const Icon( Icons.menu, color: primaryText),
    title: const Text('To- Do List',style:TextStyle(color: primaryText)),
    backgroundColor: bg,
  );

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ToDoList>{
  
  int presentComp = 0;
  int perPageComp = 3;
  int presentUncomp = 0;
  int perPageUncomp = 3;

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
          color: bg,
          //mainAxisAlignment: MainAxisAlignment.start
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child:Column(
            children: [
              Row(             
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text("Incomplete: ${incompleteTasks.length}, Complete: ${completedTasks.length}", style: const TextStyle(fontSize: 12,color: primaryText)),
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child:  Icon(Icons.filter_list, color: toDoIconCols),
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Incomplete",style: TextStyle( fontWeight: FontWeight. bold,fontSize: 14,color: primaryText)),
                    ),
                  ],
              ),            
          ],
          )        
        ),  
        Container(
            decoration: const BoxDecoration(color:bg),
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
                      color: lightPrimary.withOpacity(0.1),
                      child: TextButton(
                          child: const Opacity(
                            opacity: 0.3,
                            child: Text("More incomplteed tasks",style: TextStyle(color: primaryText)),
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
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child:Column(
            children: [
              Row(
                children: const [
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Complete",style: TextStyle( fontWeight: FontWeight. bold,fontSize: 14,color: primaryText)),
                    ),
                  ],
              ),            
          ],
          )        
        ),
        Container(
            decoration: const BoxDecoration(color:bg),
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
                      color: lightPrimary.withOpacity(0.1),
                      child: TextButton(
                      child: const Opacity(
                            opacity: 0.3,
                            child: Text("More completed tasks",style: TextStyle(color: primaryText)),
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
      shadowColor: Color.fromARGB(0, 0, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: const BoxDecoration(color: bg,borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
      child: makeListTile(index, itemsComp),
    ),
  );
}
  Widget makeCardundone(int index){
    return Card ( //static cos otherwise implicit declaration
      elevation: 8.0,
      shadowColor: Color.fromARGB(0, 0, 255, 255),
      //shape:ShapeBorder()/// ShapeDecoration(shape: Border.all(color:divider ))),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: const BoxDecoration(color:bg,borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // tileColor: const Color.fromARGB(199, 152, 182, 17),
      // shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(100.0))),
      dense: true, //assuming task title+description so keeping it true, check with false once text here
      enabled: true, //keep this false when task is completed so that object is not interactive. cant edit if task done from to do list.
      leading: Container(

          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
          border: const Border(
                  right: const BorderSide(width: 1.0, color: toDoIconCols)),
                  ),
          child: const DecoratedIcon(
            icon: Icon(Icons.check_box_outline_blank_outlined,color: toDoIconCols),
            //  decoration: IconDecoration(
            //    shadows: [Shadow(blurRadius: 0, offset: Offset(0,0))],
            //   gradient: LinearGradient(colors:[Color.fromARGB(255, 202, 202, 202),Color.fromARGB(255, 160, 159, 159)] )
            // ),
           ),
        ),
      title: Text( // this needs to have task header!!!!! sample text here
          list[index].name,
          style: TextStyle(color: primaryText, fontSize: 18),
        ),
      subtitle: Row(
          children: <Widget>[
            Text(list[index].description, style: TextStyle(color: secondaryText)),
           // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
            // so set color thru a function??
          ],
        ),
      trailing: Icon(Icons.timer, color: timerCol, size: 20.0), // not required as per our interface, or we can put that tmer here
        // we can set color of this timer from red yellow to blue based on task importance? 
    
    );
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // tileColor: const Color.fromARGB(199, 152, 182, 17),
      // shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(100.0))),
      dense: true, //assuming task title+description so keeping it true, check with false once text here
      enabled: true, //keep this false when task is completed so that object is not interactive. cant edit if task done from to do list.
      leading: Container(

          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
          border: const Border(
                  right: const BorderSide(width: 1.0,color:toDoIconCols)),
                  ),
          child: const DecoratedIcon(
            icon: Icon(Icons.check_box,color: toDoIconCols,),
            // decoration: IconDecoration(
            //   shadows: [Shadow(blurRadius: 2, offset: Offset(0,0))],
            //   gradient: LinearGradient(colors:[Color.fromARGB(255, 155, 17, 17),Color.fromARGB(255, 12, 10, 10)] )
            // ),
            ),
          ),
        title: Text( // this needs to have task header!!!!! sample text here
            list[index].name,
            style: const TextStyle(color:primaryText,  fontSize: 18),
          ),
        subtitle: Row(
            children: <Widget>[
              Text(list[index].description, style: const TextStyle(color: secondaryText)),
            // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
              // so set color thru a function??
            ],
          ),
        trailing: Icon(Icons.timer, color: timerCol, size: 20.0), // not required as per our interface, or we can put that tmer here
          // we can set color of this timer from red yellow to blue based on task importance? 
      
    );
  } 

  @override
  Widget build(BuildContext context){
    if (fetchData) {
      Storage.fetchTasks().then((v) => {
        // Reset these with every refresh
        itemsUncomp = <Task>[],
        itemsComp = <Task>[],
        presentComp = 0,
        presentUncomp = 0,

        incompleteTasks = Task.parseTasks(v["incomplete"]), 
        completedTasks = Task.parseTasks(v["complete"]), 
        setState(() => {
          fetchData = false,
          loadMoreComp(),
          loadMoreUncomp()
        }) 
      });

      return Loading();
    }
    else {
      return Scaffold (
      //appBar: ToDoList.topBar,
      backgroundColor: bg,
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
        foregroundColor: bg, //Colors.amber,
        hoverColor: accent, //Colors.green,
        //splashColor: Colors.tealAccent,

        child: const Icon(Icons.add ),
      ),
    ); 
    }
  }
}
