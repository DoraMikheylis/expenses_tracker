import 'package:expenses_tracker/data/models/models/category.dart';

class Expense {
  String expenseId;
  Category category;
  DateTime date;
  int amount;

  Expense(
      {required this.expenseId,
      required this.category,
      required this.date,
      required this.amount});

  static final empty = Expense(
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0,
  );
}
