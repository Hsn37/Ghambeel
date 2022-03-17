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
  @override
  _ToDoListState createState() => _ToDoListState();
}


class _ToDoListState extends State<ToDoList>{
  final topBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromARGB(255, 249, 250, 250),
    title: const Text('To-Do List'),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {print("heeh");},
        alignment: Alignment.center,
      )
    ],
  );
  @override
  Widget build(BuildContext context){
    return Scaffold (
      backgroundColor: Color.fromARGB(255, 250, 247, 249),
      appBar:topBar,
    );
    
  }
  
}