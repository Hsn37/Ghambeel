import 'dart:collection';
import 'dart:convert';
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
import 'package:sortedmap/sortedmap.dart';






class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StatState createState() => _StatState();
}

  // Map<String, double> pieData = {
  //   'Task1': 35.8,
  //   'Task2': 8.3,
  //   'Task3': 10.8,
  //   'Task4': 15.6,
  //   'Task5': 19.2,
  //   'Task6': 23,
  // };

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


  // var sortMapByValue = Map.fromEntries(
  //   pieData.entries.toList()
  //   ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    
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
    return
      FutureBuilder(
          future: getAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              data = snapshot.data;
              print(data[0].isEmpty);
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Time spent on tasks:",
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                        color: primaryText[darkMode],
                                        fontSize: 16,
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 18.0,),
                                data[0].isEmpty ? SizedBox(height: 18.0,) // replace this with some empty message or whatevs
                                    : PieChart(
                                  legendOptions: LegendOptions(
                                      legendPosition: LegendPosition.bottom,
                                      legendTextStyle: TextStyle(
                                        color: primaryText[darkMode],
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  dataMap: data[0], //pie data top 5 added here
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
                                ),
                              ],
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            // color: (darkMode==0) ? Color.fromARGB(255, 255, 255, 255) : Colors.grey.shade600,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Minutes spent each day:",
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                        color: primaryText[darkMode],
                                        fontSize: 16,
                                      ),),
                                  ),
                                ),
                                SizedBox(height: 18.0,),
                                // put barchart here
                                SizedBox(
                                  width: 4500,
                                  height: 300,
                                  child: DailyWorkChart(
                                    data[1], // you can get specific data like this after returning
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
                                left: 8.0,
                                top: 10.0,
                                right: 8.0,
                                bottom: 10.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Monthly heatmap:",
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.bold,
                                        color: primaryText[darkMode],
                                        fontSize: 16,
                                      ),),
                                  ),
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HeatMapCalendar(
                                    defaultColor: bg[darkMode],
                                    flexible: true,
                                    colorMode: ColorMode.color,
                                    datasets: data[2],
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
                                    // textColor:Colors.grey.shade400,
                                    weekTextColor: primaryText[darkMode],
                                    // showColorTip: true,
                                    
                                    
                                    // onClick: (value) {
                                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                                    // },
                                  ),
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

    var baraxiscolor = charts.MaterialPalette.black;
    if(darkMode == 1)
    {
      baraxiscolor = charts.MaterialPalette.white;
    }
    var axis = charts.OrdinalAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10, color: baraxiscolor), //chnage white color as per your requirement.
            ));
    var axis_measure = charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10, color: baraxiscolor), //chnage white color as per your requirement.
            ));
    return charts.BarChart(
      series, 
      animate: true,
      
      // barRendererDecorator: ,
      // primaryMeasureAxis: axis,
      domainAxis: axis,
      primaryMeasureAxis: axis_measure,
      defaultRenderer: new charts.BarRendererConfig(
        maxBarWidthPx: 40,
      
      ),
      );
      
  }
}

Future<List<DailyWork>> getBarData() async {
  List<int> prod = [0, 0, 0, 0, 0, 0, 0];
  var week = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
  List<int> tprod = [1, 2, 3, 4, 5, 6, 7];
  var tweek = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
  List<DailyWork> result = [];
  String? temp = await Storage.getValue("timeSpentPerDay");
  try {
    if (temp != "") {
      dynamic tasks = json.decode(temp!);
      for (var item in tasks.keys) {
        var now = DateTime.now();
        var tiemdone = DateTime.parse(item);
        if (now.difference(tiemdone).inDays < 7) {
          var day = DateTime.parse(item).weekday;
          int add = tasks[item];
          prod[day-1] = prod[day-1] + add;
        }
      }
    }
  }
  catch(e) {
    for (var i = 0; i < prod.length; i++) {
      result.add(DailyWork(week[i], prod[i], charts.ColorUtil.fromDartColor(Colors.cyan.shade100)));
    }
    return result;
  }

  for (var i = 0; i < prod.length; i++) {
    result.add(DailyWork(week[i], prod[i], charts.ColorUtil.fromDartColor(Colors.cyan.shade100)));
  }
  return result;
}

Future<dynamic> getPieData() async {
  String? temp = await Storage.getValue("timespentPerTask");
  dynamic alltasks = await Storage.fetchTasks();
  dynamic tasks = {};
  Map holder = SortedMap(Ordering.byValue());
  Map<String, double> result = {};
  try {
    if (temp != "") {
      tasks = json.decode(temp!);
      holder.addAll(tasks);
      var iter = holder.keys.toList().reversed;
      var count = 0;
      print(holder);
      for (var key in iter) {
        print(key);
        print(holder[key]);
        print(tasks[key]);
        print(key.runtimeType);
        print(holder[key].runtimeType);
        print(tasks[key].runtimeType);
        String tempkey = key;
        if (alltasks['complete'][tempkey] != null) {
          tempkey = alltasks['complete'][tempkey]['name'];
        }
        if (alltasks['incomplete'][tempkey] != null) {
          tempkey = alltasks['incomplete'][tempkey]['name'];
        }
        double tempval = tasks[key].toDouble();
        count = count + 1;
        // print("Result0:"+ result.toString());
        // result.putIfAbsent(key, () => holder[key]);
        result[tempkey] = tempval;
        // print("Result:"+ result.toString());
        if (count == 5) {
          break;
        }
      }
    }
  }
  catch (e) {
    print(e);
    return result;
  }
  // print("Result2:"+ holder.toString());
  print(result);

  return result;
}

Future<dynamic> getHeatData() async {
  Map<DateTime, int> result = {};
  String? temp = await Storage.getValue("timeSpentPerDay");
  try {
    if (temp != "") {
      dynamic temp2 = json.decode(temp!);
      for (var key in temp2.keys) {
        var day = DateTime.parse(key).day;
        var month = DateTime.parse(key).month;
        var year = DateTime.parse(key).year;
        result[DateTime(year, month, day)] = temp2[key];
      }
    }
  }
  catch(e) {
    return result;
  }

  return result;
}

Future<dynamic> getAllData() async {
  // this function gets data for all charts. you can do more processing here if you want.
  // bar and heatmap data should be fine as is. pie data you'll have to deal with dynamically. it
  // has top 5 or less.

  dynamic pieData = await getPieData();
  dynamic barData = await getBarData();
  dynamic heatData = await getHeatData();

  print(pieData);
  return [pieData, barData, heatData];
}

// Future<List<DailyWork>> oldgetBarData() async {
//   DailyWork temp;
//   var prod = [0, 0, 0, 0, 0, 0, 0];
//   var week = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"];
//   List<DailyWork> result = [];
//   final tasks = await Storage.fetchTasks();
//   var complete = tasks['complete'];
//   for (var key in complete.keys) {
//     var current = complete[key];
//     var added = DateTime.parse(current['timeAdded']);
//     var completed = DateTime.parse(current['timeCompleted']);
//     var priority = current['priority'];
//     var month = completed.month;
//     var day = week[completed.weekday-1];
//     var timeTaken = completed.difference(added).inSeconds; // Change this to whatever metric you want
//     if (DateTime.now().difference(completed).inDays < 7) {
//       print(timeTaken);
//       prod[completed.weekday - 1] = prod[completed.weekday - 1] + timeTaken;
//     }
//   }
//   for (var i = 0; i < prod.length; i++) {
//     result.add(DailyWork(week[i], prod[i], charts.ColorUtil.fromDartColor(Colors.cyan.shade100)));
//   }
//
//   print(result[1].day);
//   print(result[1].hours);
//
//   return result;
// }

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

