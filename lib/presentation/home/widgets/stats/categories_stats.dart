import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_state.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_item.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder<StatsCubit, StatsState> categoriesStats(
  BuildContext context,
) {
  return BlocBuilder<StatsCubit, StatsState>(builder: (context, state) {
    if (state.status == StatsStatus.success) {
      List<Expense> expenses = [];

      if (state.listMonthlyExpenses[state.pageIndex].values
          .every((expenses) => expenses.isEmpty)) {
        return const Center(child: Text('No expenses found'));
      } else {
        var categoriesMap = state.listMonthlyExpenses[state.pageIndex];

        categoriesMap.forEach((key, value) {
          var amount = value.fold(
              0.0, (previousValue, element) => previousValue + element.amount);
          expenses.add(Expense(
              amount: amount,
              category: key,
              expenseId: '',
              date: DateTime.now()));
        });
      }
      return TransactionList(
          transactions: expenses
              .map((e) => expenseToTransactionItemWithCategory(e))
              .toList(),
          onItemSelected: (itemId) {
            var selectedCategory = state
                .listMonthlyExpenses[state.pageIndex].keys
                .where((element) => element.categoryId == itemId)
                .firstOrNull;
            if (selectedCategory == null) return;
            context.read<StatsCubit>().setSelectedCategory(selectedCategory);
            Navigator.of(context).pushNamed(expensesByCategoryRoute);
          });
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  });
}
