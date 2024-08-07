import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget leftTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

  String text = (value - value.toInt() == 0) ? '\$ ${value.toInt() + 1}K' : '';

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 0,
    child: Text(text, style: style),
  );
}
