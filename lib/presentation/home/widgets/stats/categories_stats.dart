import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_state.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_item.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder<StatsCubit, StatsState> categoriesStats(
  BuildContext context,
) {
  return BlocBuilder<StatsCubit, StatsState>(builder: (context, state) {
    if (state.status == StatsStatus.success) {
      List<TransactionItem> items = [];

      if (state.listMonthlyExpenses[state.pageIndex].values
          .every((expenses) => expenses.isEmpty)) {
        return const Center(child: Text('No expenses found'));
      } else {
        var categoriesMap = state.listMonthlyExpenses[state.pageIndex];

        categoriesMap.forEach((key, value) {
          var expense = value.firstOrNull;

          if (expense == null) {
            return;
          }

          var category = expense.category;

          var amount = value.fold(
              0.0, (previousValue, element) => previousValue + element.amount);
          items.add(TransactionItem(
              itemId: category.categoryId,
              amount: amount,
              name: category.name,
              icon: category.icon,
              color: category.color));
        });
      }
      return TransactionList(
          transactions: items,
          onItemSelected: (itemId) {
            context.read<StatsCubit>().setSelectedCategory(itemId);
            Navigator.of(context).pushNamed(expensesByCategoryRoute);
          });
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  });
}
