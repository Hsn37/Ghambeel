import 'dart:collection';
// import 'dart:';

import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/task.dart';
import 'package:intl/intl.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
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

    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg[darkMode],
      body: Center(
        child: Column(
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
            Card(

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


