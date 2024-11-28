import 'package:expenses_tracker/data/repositories/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);
  Future<List<Category>> getCategories();

  Future<void> createExpense(Expense expense);
  Future<List<Expense>> getExpenses({int? limit});

  Future<void> createIncome(Income income);
  Future<List<Income>> getIncomes();

  Future<void> deleteExpense(String expenseId);

  Future<void> deleteCategory(Category category);

  Future<List<Expense>> getExpensesByCategory(String categoryId, {int? limit});
  Future<Map<String, List<Expense>>> getExpensesGroupedByCategory(
      {DateTime? date});

  Future<Category> getCategoryById(String categoryId);
}
