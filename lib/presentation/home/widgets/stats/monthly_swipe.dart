import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_state.dart';
import 'package:expenses_tracker/presentation/home/widgets/pie_chart_expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MonthlySwipe extends StatefulWidget {
  const MonthlySwipe({super.key});

  @override
  State<MonthlySwipe> createState() => _MonthlySwipeState();
}

class _MonthlySwipeState extends State<MonthlySwipe> {
  DateTime _currentDate = DateTime.now();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${_getMonthName(_currentDate.month - 1)}${_currentDate.year != DateTime.now().year ? ' ${_currentDate.year}' : ''}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 300,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                reverse: true,
                itemCount:
                    12, //исправить! вместо 12 вставить количество заполненных месяцев
                onPageChanged: (index) {
                  setState(() {
                    context.read<StatsCubit>().setPageIndex(index);
                    if (_currentIndex > index) {
                      _currentDate =
                          DateTime(_currentDate.year, _currentDate.month + 1);
                    } else {
                      _currentDate =
                          DateTime(_currentDate.year, _currentDate.month - 1);
                    }

                    _currentIndex = index;

                    context.read<StatsCubit>().getExpensesGroupedByCategory(
                        date: DateTime(
                            DateTime.now().year, _currentDate.month - 2));
                  });
                },
                itemBuilder: (context, index) {
                  return BlocBuilder<StatsCubit, StatsState>(
                      builder: (context, state) {
                    if (state.status == StatsStatus.success) {
                      if (state.listMonthlyExpenses[index].values
                          .every((expenses) => expenses.isEmpty)) {
                        return const Center(child: Text('No expenses found'));
                      } else {
                        return Center(
                            child: PieChartExpenseCategory(
                          expensesMap: state.listMonthlyExpenses[index],
                        ));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  });
                },
              ),
              AnimatedSmoothIndicator(
                  activeIndex: 12 -
                      _currentIndex -
                      1, //исправить! вместо 12 вставить количество заполненных месяцев
                  count: 12,
                  effect: ScrollingDotsEffect(
                      dotWidth: 12,
                      dotHeight: 12,
                      dotColor: Theme.of(context).colorScheme.outline,
                      activeDotColor: Theme.of(context).colorScheme.tertiary),
                  onDotClicked: (index) {}),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int index) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[index % 12];
  }
}
