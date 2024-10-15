import 'package:expenses_tracker/data/models/category.dart';

class Expense {
  String expenseId;
  Category category;
  DateTime date;
  double amount;

  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
  });
  static Expense createEmpty() {
    return Expense(
      expenseId: '',
      category: Category.createEmpty(),
      date: DateTime.now(),
      amount: 0.0,
    );
  }
}
