// ignore_for_file: unnecessary_const
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';

// import 'package:ghambeel/main.dart';

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


class ToDoList extends StatefulWidget{
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;

  static final topBar = AppBar(
    leading: const Icon( Icons.menu, color:Color.fromARGB(255, 47, 10, 180)),
    title: const Text('Page title'),
    
    backgroundColor: Colors.purple,
  );

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList>{
  
  // ignore: avoid_unnecessary_containers
  final makeBody = Container(
      decoration: const BoxDecoration(color:Color.fromARGB(146, 255, 255, 255),borderRadius:BorderRadius.all(Radius.circular(3.0))),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        
        shrinkWrap: true,
        itemCount: 10, // number here shold be the sum of items in to do list
        itemBuilder: (BuildContext context, int index) {
          return makeCard; // make card creates the items. receive data from make card for our tasks
        },
    ),
  );
  static final makeCard = Card( //static cos otherwise implicit declaration
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: const BoxDecoration(color: Color.fromARGB(146, 255, 255, 255),borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
      child: makeListTile,
    ),
  );
  // see options for this.
  static final makeListTile = ListTile( 
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      dense: true, //assuming task title+description so keeping it true, check with false once text here
      enabled: true, //keep this false when task is completed so that object is not interactive. cant edit if task done from to do list.
      leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
          border: const Border(
                  right: const BorderSide(width: 1.0, color: Colors.white24))),
          child: const DecoratedIcon(
            icon: Icon(Icons.check_box_outline_blank_outlined),
            decoration: IconDecoration(
              shadows: [Shadow(blurRadius: 2, offset: Offset(0,0))],
              gradient: LinearGradient(colors:[Colors.grey,Colors.grey] )
            ),
           ),
        ),
      title: const Text( // this needs to have task header!!!!! sample text here
          "task title",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 22),
        ),
      subtitle: Row(
          children: const <Widget>[
            Text(" Task description", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
           // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
            // so set color thru a function??
          ],
        ),
      trailing: const Icon(Icons.timer, color: Colors.white, size: 20.0), // not required as per our interface, or we can put that tmer here
        // we can set color of this timer from red yellow to blue based on task importance? 
    
  );

  @override
  Widget build(BuildContext context){
    return Scaffold (
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      body:makeBody,
    );
    
  }
}
