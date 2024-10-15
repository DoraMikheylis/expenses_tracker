import 'package:expenses_tracker/data/models/models.dart';

class TransactionItem {
  final String? itemId;
  final double amount;
  final String name;
  final String icon;
  final int color;
  final DateTime? date;

  TransactionItem({
    this.itemId,
    required this.amount,
    required this.name,
    required this.icon,
    required this.color,
    this.date,
  });
}

TransactionItem expenseToTransactionItem(Expense expense) {
  return TransactionItem(
    itemId: expense.expenseId,
    amount: expense.amount,
    name: expense.category.name,
    icon: expense.category.icon,
    color: expense.category.color,
    date: expense.date,
  );
}

TransactionItem expenseToTransactionItemWithCategory(Expense expense) {
  return TransactionItem(
    itemId: expense.category.categoryId,
    amount: expense.amount,
    name: expense.category.name,
    icon: expense.category.icon,
    color: expense.category.color,
    date: expense.date,
  );
}

TransactionItem incomeToTransactionItem(Income income) {
  return TransactionItem(
    amount: income.amount,
    name: 'Income',
    icon: '',
    color: 0,
    date: income.date,
  );
}
