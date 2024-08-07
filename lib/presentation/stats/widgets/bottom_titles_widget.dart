import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget bottomTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

  Widget text =
      Text((value.toInt() + 1).toString().padLeft(2, '0'), style: style);

  return SideTitleWidget(axisSide: meta.axisSide, space: 16.0, child: text);
}
