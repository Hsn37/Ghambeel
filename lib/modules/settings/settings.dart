// // ignore_for_file: unnecessary_const, deprecated_member_use, curly_braces_in_flow_control_structures
// import 'dart:async';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:ghambeel/modules/storage/storage.dart';
// import 'package:ghambeel/modules/todolist/addtask.dart';
// import 'package:ghambeel/modules/todolist/edittask.dart';
// import 'package:ghambeel/modules/todolist/filter.dart';
// import 'package:ghambeel/modules/todolist/viewtasks.dart';
// import 'package:ghambeel/sharedfolder/loading.dart';
// import 'package:icon_decoration/icon_decoration.dart';
// import 'package:flutter/material.dart';
// import 'package:ghambeel/sharedfolder/task.dart';
// import '../../theme.dart';
// import 'package:path_provider/path_provider.dart';

// import '../todolist/todolist.dart';

// class topBar extends AppBar {
//     final String myTitle;
//     topBar({Key? key, required BuildContext context,required this.myTitle})
//     : super(
//         key: key,
//         leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: primaryText, ),           
//               onPressed: () {
//                   Navigator.pop(
//                     context,
//                  // MaterialPageRoute(builder: (context) => const ToDoList(title: 'To-Do List',)), //change to  side bar menu
//                 );
//             }
            
//         ),
//       title: const Text('Settings',style: TextStyle(color: primaryText),),
//       backgroundColor: bg,
//     );
// }

// class Settings extends StatefulWidget{
//   const Settings({Key? key, required this.title}) : super(key: key);
//   final String title;
//   static final topBar = AppBar(
//     leading: const Icon( Icons.menu, color: primaryText),
//     title: const Text('Settings',style:TextStyle(color: primaryText)),
//     backgroundColor: bg,
//   );

//   @override
//   SettingsState createState() => SettingsState();
// }

// class SettingsState extends State<Settings>{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
    
    
//   }


// }
  