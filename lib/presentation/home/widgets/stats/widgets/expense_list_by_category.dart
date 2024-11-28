import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_state.dart';
import 'package:expenses_tracker/data/models/category.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_item.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseListByCategory extends StatefulWidget {
  const ExpenseListByCategory({super.key});

  @override
  State<ExpenseListByCategory> createState() => _ExpenseListByCategoryState();
}

class _ExpenseListByCategoryState extends State<ExpenseListByCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses by category'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 25.0,
        ),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<StatsCubit, StatsState>(builder: (context, state) {
                if (state.status == StatsStatus.success) {
                  var categoriesMap =
                      state.listMonthlyExpenses[state.pageIndex];
                  if (state.selectedCategory == null) {
                    return const Center(child: Text('No category selected'));
                  }
                  Category category = state.selectedCategory!;

                  if (categoriesMap.containsKey(category.categoryId) &&
                      categoriesMap[category.categoryId]!.isNotEmpty) {
                    return TransactionList(
                        transactions: categoriesMap[category.categoryId]!
                            .map((e) => expenseToTransactionItem(e))
                            .toList(),
                        slidableActions: (itemId) {
                          return [
                            SlidableAction(
                              onPressed: (context) {
                                var selectedExpense =
                                    categoriesMap[category.categoryId]!
                                        .where((e) => e.expenseId == itemId)
                                        .first;

                                context.read<ExpenseBloc>().add(
                                    DeleteExpenseEvent(
                                        expenseId: selectedExpense.expenseId));
                                context
                                    .read<StatsCubit>()
                                    .getExpensesGroupedByCategoryByMonth(
                                        date: DateTime.now());
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ];
                        });
                  } else {
                    return const Center(child: Text('No expenses found'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
