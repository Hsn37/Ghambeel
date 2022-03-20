// ignore_for_file: unnecessary_const, deprecated_member_use
import 'package:ghambeel/modules/todolist/addtask.dart';
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


class ToDoList extends StatefulWidget{
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;
  static final topBar = AppBar(
    leading: const Icon( Icons.menu, color: primaryText),
    title: const Text('To- Do List',style:TextStyle(color: primaryText)),
    backgroundColor: bg,
  );

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList>{
  
  static int presentComp = 0;
  static int perPageComp = 3;
  static int presentUncomp = 0;
  static int perPageUncomp = 3;

  static final originalItems = List<String>.generate(10, (i) => "Item $i");
  static var itemsComp = <String>[];
  static var itemsUncomp = <String>[];
  
  @override
  void initState() {
      super.initState();
      setState(() {
        itemsComp.addAll(originalItems.getRange(presentComp, presentComp + perPageComp));
        presentComp = presentComp + perPageComp;
        itemsUncomp.addAll(originalItems.getRange(presentUncomp, presentUncomp + perPageUncomp));
        presentUncomp = presentUncomp + perPageUncomp;
      });
      
    }
  void loadMoreComp() {
      setState(() {
        if((presentComp + perPageComp )> originalItems.length) {
          itemsComp.addAll(
              originalItems.getRange(presentComp, originalItems.length));
        } else {
          itemsComp.addAll(
              originalItems.getRange(presentComp, presentComp + perPageComp));
        }
        presentComp = presentComp + perPageComp;
      });
    
  }
  void loadMoreUncomp() {
      setState(() {
        if((presentUncomp + perPageUncomp )> originalItems.length) {
          itemsUncomp.addAll(
              originalItems.getRange(presentUncomp, originalItems.length));
        } else {
          itemsUncomp.addAll(
              originalItems.getRange(presentUncomp, presentUncomp + perPageUncomp));
        }
        presentUncomp = presentUncomp + perPageUncomp;
      });
    
  }
  Widget makeBody(BuildContext context){
  // final makeBody = 
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
              children: const [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text("5 incomplete, 5 complete",style: TextStyle(fontSize: 12,color: primaryText)),
                  ),
                Padding(
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
              itemCount: (presentComp <= originalItems.length) ? itemsComp.length + 1 : itemsComp.length,
              itemBuilder: (context, index) {
                return (index == itemsComp.length ) ?
                  Container(
                    color: lightPrimary.withOpacity(0.1),
                    child: TextButton(
                        child: const Opacity(
                          opacity: 0.3,
                          child: Text("More incomplteed tasks",style: TextStyle(color: primaryText)),
                        ),
                      // child: const Text("Load More",style: TextStyle(color: Colors.black.withOpacity(0.5))
                      onPressed: () {
                        loadMoreComp();
                      },
                    ),
                  )
                      :
                      makeCardundone();
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
              itemCount: (presentUncomp <= originalItems.length) ? itemsUncomp.length + 1 : itemsUncomp.length,
              itemBuilder: (context, index) {
                return (index == itemsUncomp.length ) ?
                  Container(
                    color: lightPrimary.withOpacity(0.1),
                    child: TextButton(
                     child: const Opacity(
                          opacity: 0.3,
                          child: Text("More completed tasks",style: TextStyle(color: primaryText)),
                    ),
                      onPressed: () {
                        loadMoreUncomp();
                      },
                    ),
                  )
                      :
                      makeCarddone();
                },          
            ),
      ),
   ]    
);
}
  Widget makeCarddone() {
    return Card ( //static cos otherwise implicit declaration
      elevation: 8.0,
      shadowColor: Color.fromARGB(0, 0, 255, 255),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: const BoxDecoration(color: bg,borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
      child: makeListTile,
    ),
  );
}
  Widget makeCardundone(){
    return Card ( //static cos otherwise implicit declaration
      elevation: 8.0,
      shadowColor: Color.fromARGB(0, 0, 255, 255),
      //shape:ShapeBorder()/// ShapeDecoration(shape: Border.all(color:divider ))),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
      decoration: const BoxDecoration(color:bg,borderRadius:BorderRadius.all(Radius.circular(50.0))),// function call check task urgency, select and return color!!!
      child: makeListTileUncomp,
    ),
  );
}
static final makeListTileUncomp = ListTile( 
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
      title: const Text( // this needs to have task header!!!!! sample text here
          "task title",
          style: TextStyle(color: primaryText, fontSize: 18),
        ),
      subtitle: Row(
          children: const <Widget>[
            Text(" Task description", style: TextStyle(color: secondaryText)),
           // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
            // so set color thru a function??
          ],
        ),
      trailing: const Icon(Icons.timer, color: toDoIconCols, size: 20.0), // not required as per our interface, or we can put that tmer here
        // we can set color of this timer from red yellow to blue based on task importance? 
    
  );
  // see options for this.
  static final makeListTile = ListTile( 
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
      title: const Text( // this needs to have task header!!!!! sample text here
          "task title",
          style: TextStyle(color:primaryText,  fontSize: 18),
        ),
      subtitle: Row(
          children: const <Widget>[
            Text(" Task description", style: TextStyle(color: secondaryText)),
           // Icon(Icons.timer, color: Color.fromARGB(255, 255, 0, 0), ),
            // so set color thru a function??
          ],
        ),
      trailing: const Icon(Icons.timer, color: toDoIconCols, size: 20.0), // not required as per our interface, or we can put that tmer here
        // we can set color of this timer from red yellow to blue based on task importance? 
    
  );

  @override
  Widget build(BuildContext context){
    return Scaffold (
      //appBar: ToDoList.topBar,
      backgroundColor: bg,
      body:makeBody(context),
      floatingActionButton: FloatingActionButton(
        //splashColor: plusFloatCol,
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const addTask(title: 'Add A Task')),
        );
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
