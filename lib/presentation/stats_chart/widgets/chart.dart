// import 'dart:math';

// import 'package:expenses_tracker/presentation/linear_gradient.dart';
// import 'package:expenses_tracker/presentation/stats/widgets/bottom_titles_widget.dart';
// import 'package:expenses_tracker/presentation/stats/widgets/left_titles_widget.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class Chart extends StatefulWidget {
//   const Chart({super.key});

//   @override
//   State<Chart> createState() => _ChartState();
// }

// class _ChartState extends State<Chart> {
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(mainBarData());
//   }

//   BarChartGroupData makeGroupData(int x, double amount) {
//     return BarChartGroupData(x: x, barRods: [
//       BarChartRodData(
//           gradient: reverseLinearGradient(context, 70),
//           toY: amount,
//           width: 10,
//           backDrawRodData: BackgroundBarChartRodData(
//               show: true, toY: 4, color: Colors.grey.shade300)),
//     ]);
//   }

//   List<BarChartGroupData> showingGroups() => List.generate(8, (i) {
//         return makeGroupData(i, Random().nextDouble() * 4.0);
//       });

//   BarChartData mainBarData() {
//     return BarChartData(
//       titlesData: const FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 38,
//               getTitlesWidget: bottomTitles),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitles,
//             reservedSize: 40,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(show: false),
//       gridData: const FlGridData(show: false),
//       barGroups: showingGroups(),
//     );
//   }
// }
