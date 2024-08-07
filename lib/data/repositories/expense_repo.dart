import 'package:expenses_tracker/data/repositories/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
  Future<List<Category>> getCategory();

  Future<void> createExpense(Expense expense);
  Future<List<Expense>> getExpense();
}