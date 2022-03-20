import 'package:flutter/material.dart';
import 'package:ghambeel/modules/todolist/addtask.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import '../../theme.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {

  int present = 0;
  int perPage = 5;

  final originalItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];


  @override
  void initState() {
    super.initState();
    setState(() {
      items.addAll(originalItems.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  void loadMore() {
    setState(() {
      if((present + perPage )> originalItems.length) {
        items.addAll(
            originalItems.getRange(present, originalItems.length));
      } else {
        items.addAll(
            originalItems.getRange(present, present + perPage));
      }
      present = present + perPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text(widget.title),
      ),
     
        body:
        Container(
        decoration: const BoxDecoration(color:Color.fromARGB(255, 255, 255, 255)),
        
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: ListView.builder(
          itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
          itemBuilder: (context, index) {
            return (index == items.length ) ?
            Container(
              color: Colors.greenAccent,
              child: TextButton(
                child: const Text("Load More"),
                onPressed: () {
                  setState(() {
                    if((present + perPage )> originalItems.length) {
                      items.addAll(
                          originalItems.getRange(present, originalItems.length));
                    } else {
                      items.addAll(
                          originalItems.getRange(present, present + perPage));
                    }
                    present = present + perPage;
                  });
                },
              ),
            )
                :
            ListTile(
              title: Text(items[index]),
            );
          },
        ),
      )
    );

  }
}