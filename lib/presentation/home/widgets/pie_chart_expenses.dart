import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/home/utilities/darken_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/models.dart';

class PieChartExpenseCategory extends StatefulWidget {
  final Map<String, List<Expense>> expensesMap;

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

List<PieChartSectionData> showingSections(
    Map<String, List<Expense>> expensesMap, int touchedIndex) {
  double totalExpenses = expensesMap.values
      .expand((expenses) => expenses)
      .fold(0.0, (sum, expense) => sum + expense.amount);

  return List.generate(expensesMap.keys.length, (i) {
    final expense = expensesMap.values.toList()[i].firstOrNull;

    if (expense == null) {
      return PieChartSectionData(
        color: Colors.transparent,
        value: 0,
        title: '',
        radius: 0,
        titleStyle: const TextStyle(color: Colors.transparent),
      );
    }

    final category = expense.category;

    final amount = expensesMap[category.categoryId]!
        .fold(0.0, (previousValue, element) => previousValue + element.amount);
    final percentage = (amount / totalExpenses) * 100;

    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 20.0 : 16.0;
    final radius = isTouched ? 110.0 : 100.0;
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
