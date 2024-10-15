import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/home/utilities/darken_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/models.dart';

class PieChartExpenseCategory extends StatefulWidget {
  final Map<Category, List<Expense>> expensesMap;

  const PieChartExpenseCategory({
    super.key,
    required this.expensesMap,
  });

  @override
  PieChartExpenseCategoryState createState() => PieChartExpenseCategoryState();
}

class PieChartExpenseCategoryState extends State<PieChartExpenseCategory> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            if (event is FlLongPressStart &&
                pieTouchResponse != null &&
                pieTouchResponse.touchedSection != null) {
              int touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;

              if (touchedIndex >= 0 &&
                  touchedIndex < widget.expensesMap.keys.length) {
                context.read<StatsCubit>().setSelectedCategory(
                      widget.expensesMap.keys.toList()[touchedIndex],
                    );
                Navigator.pushNamed(context, expensesByCategoryRoute);
              }
            }

            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              setState(() {
                touchedIndex = -1;
              });
              return;
            }

            setState(() {
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: showingSections(widget.expensesMap, touchedIndex),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}

List<PieChartSectionData> showingSections(
    Map<Category, List<Expense>> expensesMap, int touchedIndex) {
  double totalExpenses = expensesMap.values
      .expand((expenses) => expenses)
      .fold(0.0, (sum, expense) => sum + expense.amount);

  return List.generate(expensesMap.keys.length, (i) {
    final category = expensesMap.keys.toList()[i];
    final amount = expensesMap[category]!
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
    final percentage = (amount / totalExpenses) * 100;

    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 20.0 : 16.0;
    final radius = isTouched ? 110.0 : 100.0;
    // final widgetSize = isTouched ? 55.0 : 40.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    return PieChartSectionData(
      color: Color(category.color),
      value: amount,
      title: category.name,
      radius: radius,
      borderSide: BorderSide(
        color: darkenColor(category.color, 0.2),
      ),
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: shadows,
      ),
      badgeWidget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: darkenColor(category.color, 0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            '${percentage.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          ),
        ),
      ),
      badgePositionPercentageOffset: 1.0,
    );
  });
}
