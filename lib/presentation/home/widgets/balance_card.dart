import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/business_logic/income_cubit/income_cubit.dart';
import 'package:expenses_tracker/business_logic/income_cubit/income_state.dart';
import 'package:expenses_tracker/presentation/home/widgets/row_operations.dart';
import 'package:expenses_tracker/presentation/linear_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Container balanceCard(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 4,
    decoration: BoxDecoration(
        gradient: reverseLinearGradient(context, 6),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Colors.grey.shade400,
            spreadRadius: 5,
            offset: const Offset(3, 10),
          ),
        ]),
    child: Builder(
      builder: (context) {
        final ExpenseState expenseState = context.watch<ExpenseBloc>().state;
        final IncomeState incomeState = context.watch<IncomeCubit>().state;

        if (expenseState is GetExpensesSuccess &&
            incomeState.status == IncomeStatus.success) {
          double sumExpenses = 0;
          double sumIncomes = 0;
          if (expenseState.expenses.isNotEmpty) {
            sumExpenses = expenseState.expenses
                .map((e) => e.amount)
                .reduce((value, element) => value + element);
          }

          if (incomeState.incomes.isNotEmpty) {
            sumIncomes = incomeState.incomes
                .map((e) => e.amount)
                .reduce((value, element) => value + element);
          }
          final double balance = sumIncomes - sumExpenses;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    balance.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(
                    FontAwesomeIcons.lariSign,
                    color: Colors.white,
                    size: 38,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rowOperationsMainScreen(
                        title: 'Income',
                        amount: sumIncomes.toStringAsFixed(2),
                        icon: CupertinoIcons.arrow_down,
                        iconColor: Colors.greenAccent[400]),
                    rowOperationsMainScreen(
                        title: 'Expenses',
                        amount: '- ${sumExpenses.toStringAsFixed(2)}',
                        icon: CupertinoIcons.arrow_up,
                        iconColor: Colors.redAccent[400]),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}
