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
        child: PieChart(
          dataMap: pieData,
          colorList: mycolorList,
          chartRadius: MediaQuery.of(context).size.width /2,
          chartType: ChartType.ring,
          ringStrokeWidth: 50,
          chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
          // showChartValueBackground: false
          ),
          ),
        ),
    );
}
}