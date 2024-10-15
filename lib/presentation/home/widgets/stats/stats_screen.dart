import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/categories_stats.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/monthly_swipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    context.read<StatsCubit>().setPageIndex(0);
    context
        .read<StatsCubit>()
        .getExpensesGroupedByCategoryByMonth(date: DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 25.0,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const MonthlySwipe(),
              // const SizedBox(height: 20),
              // const PeriodSelection(),
              const SizedBox(height: 50),
              categoriesStats(
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
