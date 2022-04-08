import 'dart:collection';
// import 'dart:';

import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import '../../theme.dart';


class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StatState createState() => _StatState();
}

class _StatState extends State<Statistics> {

      Map<String, double> pieData = {
      'Task1': 35.8,
      'Task2': 8.3,
      'Task3': 10.8,
      'Task4': 15.6,
      'Task5': 19.2,
      };

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

final List<DailyWork> data = [
  DailyWork("Mon", 2, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Tues", 4, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Wed", 3, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Thurs", 6, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Fri", 0, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Sat", 8, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
  DailyWork("Sun", 3, charts.ColorUtil.fromDartColor(Colors.cyan.shade100)),
];

// List<charts.Series<DailyWork, String>> series = [
//   charts.Series(
//     id: "Daily Work",
//     data: data,
//     domainFn:, 
//     measureFn:,
//   )
// ];


    Widget build(BuildContext context) {
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
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
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
                      dataMap: pieData,
                      colorList: mycolorList,
                      chartRadius: MediaQuery.of(context).size.width /2,
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
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
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
            ],
        )
        ),
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

