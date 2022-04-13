import 'dart:collection';
import 'dart:ui';
// import 'dart:';

import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import '../../theme.dart';
// import 'package:heatmap_calendar/heatmap_calendar.dart';
// import 'package:heatmap_calendar/time_utils.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:sortedmap/sortedmap.dart';





class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StatState createState() => _StatState();
}

  Map<String, double> pieData = {
    'Task1': 35.8,
    'Task2': 8.3,
    'Task3': 10.8,
    'Task4': 15.6,
    'Task5': 19.2,
    'Task6': 23,
  };

  // Map<String, double> getTop5(Map map)
  // {
  //   Map<String, double> ret = {};
  //   for (var i = 0; i < 5; i++) {
  //     ret.add()
  //   }
     
  //   return ret;
  // }
class _StatState extends State<Statistics> {

  // var sorteddatapie = SortedMap(Ordering.byValue());


  var sortMapByValue = Map.fromEntries(
    pieData.entries.toList()
    ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    
  // print("***Sorted Map by value***");
  // print(sortMapByValue);


  
  

  List<Color> mycolorList = [
    const Color(0xffFE9539),
    const Color(0xffffe0b2),
    const Color(0xffffd54f),
    const Color(0xff00bcd4),
    const Color(0xffb2ebf2),
  ];

// Map<String, int> barData = {
//   'Mon' : 2,
//   'Tues':4,
//   'Wed': 3,
//   'Thurs' : 6,
//   'Fri' : 0,
//   'Sat': 8,
//   'Sun': 3,
// };

  dynamic data = [];

// List<charts.Series<DailyWork, String>> series = [
//   charts.Series(
//     id: "Daily Work",
//     data: data,
//     domainFn:, 
//     measureFn:,
//   )
// ];
  Map<DateTime, int> heatMapDatasets = {
    DateTime(2022, 4, 6): 3,
    DateTime(2022, 4, 7): 7,
    DateTime(2022, 4, 8): 10,
    DateTime(2022, 4, 9): 13,
    DateTime(2022, 4, 13): 6,
  };


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromRGBO(197, 244, 250, 1),
                  Color.fromRGBO(255, 223, 126, 1)
                ]
            )
        ),
        child: FutureBuilder(
          future: getBarData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              data = snapshot.data;
              return Scaffold(
                backgroundColor: bg[darkMode],
                body: Center(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: bg[darkMode],
                            elevation: 2.0,
                            shadowColor: bg[(darkMode + 1) % 2],
                            margin: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            // color: Colors.white,
                            // shadowColor: Colors.grey,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Time spent on tasks:",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.bold,
                                      color: primaryText[darkMode],
                                      fontSize: 16,
                                    ),),
                                ),
                                SizedBox(height: 18.0,),
                                PieChart(
                                  legendOptions: LegendOptions(
                                      legendPosition: LegendPosition.bottom,
                                      legendTextStyle: TextStyle(
                                        color: primaryText[darkMode],
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  dataMap: sortMapByValue,
                                  colorList: mycolorList,
                                  chartRadius: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  chartType: ChartType.ring,
                                  // ringStrokeWidth: 50,
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValuesOutside: true,
                                    // showChartValueBackground: false
                                  ),
                                )
                              ],
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: bg[darkMode],
                            elevation: 2.0,
                            shadowColor: bg[(darkMode + 1) % 2],
                            margin: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Hours spent each day:",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.bold,
                                      color: primaryText[darkMode],
                                      fontSize: 16,
                                    ),),
                                ),
                                SizedBox(height: 18.0,),
                                // put barchart here
                                SizedBox(
                                  width: 4500,
                                  height: 300,
                                  child: DailyWorkChart(
                                    data,
                                    // animate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: bg[darkMode],
                            elevation: 2.0,
                            shadowColor: bg[(darkMode + 1) % 2],
                            margin: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Monthly heatmap:",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.bold,
                                      color: primaryText[darkMode],
                                      fontSize: 16,
                                    ),),
                                ),
                                SizedBox(height: 18.0,),
                                // put barchart here
                                // SizedBox(
                                //   width: 4500,
                                //   height: 300,
                                //   child: DailyWorkChart(
                                //     data,
                                //     // animate: false,
                                //   ),
                                // ),
                                HeatMapCalendar(
                                  defaultColor: Colors.white,
                                  flexible: true,
                                  colorMode: ColorMode.color,
                                  datasets: heatMapDatasets,
                                  colorsets: {
                                    1: Colors.amber.shade50,
                                    3: Colors.amber.shade100,
                                    5: Colors.amber.shade200,
                                    7: Colors.amber.shade300,
                                    8: Colors.amber.shade400,
                                    // 11: Colors.indigo,
                                    // 13: Colors.purple,
                                  },
                                  textColor: primaryText[darkMode],
                                  weekTextColor: primaryText[darkMode],

                                  // onClick: (value) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                                  // },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
              );
            }
            else {
              return const CircularProgressIndicator();
            }

          },
        )
    );
  }
}


// Text("Time spent on tasks over the week:"),
// Expanded(
// child: PieChart(
// dataMap: pieData,
// colorList: mycolorList,
// chartRadius: MediaQuery.of(context).size.width /2,
// chartType: ChartType.ring,
// ringStrokeWidth: 70,
// chartValuesOptions: ChartValuesOptions(
// showChartValuesOutside: true,
// // showChartValueBackground: false
// ),
// )
//
// )

class DailyWork{
  late String day;
  late int hours;
  late charts.Color barColor;

  DailyWork(day, hours, color)
    {
      this.day = day; 
      this.hours = hours;
      this.barColor = color;
    }
  
}

class DailyWorkChart extends StatelessWidget {
  late List<DailyWork> data;

  DailyWorkChart(data)
  {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DailyWork, String>> series = [
      charts.Series(
        id: "Daily Workk",
        data: data,
        domainFn: (DailyWork series, _) => series.day,
        measureFn: (DailyWork series, _)=> series.hours,
        colorFn: (DailyWork series, _) => series.barColor,
      )
    ];
    return charts.BarChart(
      series, 
      animate: true,
      defaultRenderer: new charts.BarRendererConfig(
        maxBarWidthPx: 40,
      ),
      );
  }
}

Future<List<DailyWork>> getBarData() async {
  DailyWork temp;
  var prod = [0, 0, 0, 0, 0, 0, 0];
  var week = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
  List<DailyWork> result = [];
  final tasks = await Storage.fetchTasks();
  var complete = tasks['complete'];
  for (var key in complete.keys) {
    var current = complete[key];
    var added = DateTime.parse(current['timeAdded']);
    var completed = DateTime.parse(current['timeCompleted']);
    var priority = current['priority'];
    var month = completed.month;
    var day = week[completed.weekday-1];
    var timeTaken = completed.difference(added).inSeconds; // Change this to whatever metric you want
    if (DateTime.now().difference(completed).inDays < 7) {
      print(timeTaken);
      prod[completed.weekday - 1] = prod[completed.weekday - 1] + timeTaken;
    }
  }
  for (var i = 0; i < prod.length; i++) {
    result.add(DailyWork(week[i], prod[i], charts.ColorUtil.fromDartColor(Colors.cyan.shade100)));
  }

  print(result[1].day);
  print(result[1].hours);

  return result;
}

// Future<Map<String, double>> getPieData() async {
//   final tasks = await Storage.fetchTasks();
//   var complete = tasks['complete'];
//   var total = [];
//   for (var key in complete.keys) {
//     var current = complete[key];
//     var added = DateTime.parse(current['timeAdded']);
//     var completed = DateTime.parse(current['timeCompleted']);
//     var priority = current['priority'];
//     var month = completed.month;
//     var timeTaken = completed.difference(added).inSeconds;
//     total.add(timeTaken);
//   }
//   var sum = total.reduce((a, b) => a + b);
//   var result = [for (var e in total) e / sum];
//   result.sort();
//
//   return result;
// }

