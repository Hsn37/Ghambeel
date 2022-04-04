// import 'dart:collection';
// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:ghambeel/sharedfolder/task.dart';
// import 'package:intl/intl.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import '../../theme.dart';

// class Statistics extends StatefulWidget {
//   const Statistics({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   _StatState createState() => _StatState();
// }

// class _StatState extends State<Statistics> {
  
//   List<charts.Series<Task,String>> _seriesPieData = [];
  
//   // pie chart will show top five tasks 

//   _generateData()
//   {
    
//     var pieData = [
//       new Task('Task1', 35.8, Color(0xffD95AF3)),
//       new Task('Task2', 8.3, Color(0x0097A7)),
//       new Task('Task3', 10.8, Color(0xFF973B)),
//       new Task('Task4', 15.6, Color(0xFCEBB9)),
//       new Task('Task5', 19.2, Color(0xFEE2CF)),
//     ];

//     _seriesPieData.add(
//       charts.Series(
//         data: pieData,
//         domainFn: (Task task,_)=> task.task,
//         measureFn: (Task task,_)=> task.taskval,
//         colorFn: (Task task,_)=> 
//         charts.ColorUtil.fromDartColor(task.colorval),
//         id: 'Assignment Task',
//         labelAccessorFn: (Task row,_)=> '${row.taskval}',
//       )
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     // List<charts.Series<Task,String>> _seriesPieData = [];
//     _generateData();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return (
//       // title: 'Stats page',
//       // home: Text('check ')
//         // home: DefaultTabController(
//         // length: 1,
//         Scaffold(
//           // appBar: AppBar(
//             backgroundColor: Colors.white,
//           //   //backgroundColor: Color(0xff308e1c),
//           //   bottom: TabBar(
//           //     indicatorColor: Color(0xff9962D0),
//           //     tabs: [
//           //       // Tab(
//           //       //   icon: Icon(FontAwesomeIcons.solidChartBar),
//           //       // ),
//           //       Tab(icon: Icon(FontAwesomeIcons.chartPie)),
//           //       // Tab(icon: Icon(FontAwesomeIcons.chartLine)),
//           //     ],
//           //   ),
//           //   title: Text('Flutter Charts'),
//           // ),
//           // body: TabBarView(
//             body: Center(
//               // Padding(
//               //   padding: EdgeInsets.all(8.0),
//               //   child: Container(
//               //     child: Center(
//               //       child: Column(
//               //         children: <Widget>[
//               //           Text(
//               //               'SO₂ emissions, by world region (in million tonnes)',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
//               //           Expanded(
//               //             child: charts.BarChart(
//               //               _seriesData,
//               //               animate: true,
//               //               barGroupingType: charts.BarGroupingType.grouped,
//               //               //behaviors: [new charts.SeriesLegend()],
//               //               animationDuration: Duration(seconds: 5),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // children: [
//                 // padding: EdgeInsets.all(8.0),
//                 child: Container(
//                   child: Center(
//                     child: Column(
//                       children: <Widget>[
//                         Text(
//                             'Time spent on daily tasks',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
//                             SizedBox(height: 10.0,),
//                         Expanded(
//                           child: charts.PieChart(
//                             _seriesPieData,
//                             animate: true,
//                             animationDuration: Duration(seconds: 5),
//                              behaviors: [
//                             new charts.DatumLegend(
//                               outsideJustification: charts.OutsideJustification.endDrawArea,
//                               horizontalFirst: false,
//                               desiredMaxRows: 2,
//                               cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
//                               entryTextStyle: charts.TextStyleSpec(
//                                   color: charts.MaterialPalette.purple.shadeDefault,
//                                   fontFamily: 'Georgia',
//                                   fontSize: 11),
//                             )
//                           ],
//                            defaultRenderer: new charts.ArcRendererConfig(
//                               arcWidth: 100,
//                              arcRendererDecorators: [
//           new charts.ArcLabelDecorator(
//               labelPosition: charts.ArcLabelPosition.inside)
//         ])),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       //         Padding(
//       //           padding: EdgeInsets.all(8.0),
//       //           child: Container(
//       //             child: Center(
//       //               child: Column(
//       //                 children: <Widget>[
//       //                   Text(
//       //                       'Sales for the first 5 years',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
//       //                   Expanded(
//       //                     child: charts.LineChart(
//       //                       _seriesLineData,
//       //                       defaultRenderer: new charts.LineRendererConfig(
//       //                           includeArea: true, stacked: true),
//       //                       animate: true,
//       //                       animationDuration: Duration(seconds: 5),
//       //                       behaviors: [
//       //   new charts.ChartTitle('Years',
//       //       behaviorPosition: charts.BehaviorPosition.bottom,
//       //       titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
//       //   new charts.ChartTitle('Sales',
//       //       behaviorPosition: charts.BehaviorPosition.start,
//       //       titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
//       //   new charts.ChartTitle('Departments',
//       //       behaviorPosition: charts.BehaviorPosition.end,
//       //       titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
//       //       )   
//       // ]
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ),
//       //           ),
//       //         ),
//             // ],
//           // ),
//         )
//       );
//   }
// }

// // data container 

// class Task{
//   String task;
//   double taskval;
//   Color colorval;


//   Task(this.task, this.taskval, this.colorval);
// }





