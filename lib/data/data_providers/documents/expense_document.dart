import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/data/models/expense.dart';
import 'package:expenses_tracker/data/data_providers/documents/category_document.dart';

class ExpenseDocument {
  String expenseId;
  CategoryDocument category;
  DateTime date;
  double amount;

  ExpenseDocument({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
  });

  Map<String, Object> toDocument() {
    return {
      'expenseId': expenseId,
      'category': category.toDocument(),
      'date': date,
      'amount': amount,
    };
  }

  static ExpenseDocument fromDocument(Map<String, dynamic> document) {
    return ExpenseDocument(
      expenseId: document['expenseId'] as String,
      category: CategoryDocument.fromDocument(document['category']),
      date: (document['date'] as Timestamp).toDate(),
      amount: (document['amount'] as num).toDouble(),
    );
  }

  Expense toExpense() {
    return Expense(
      expenseId: expenseId,
      category: category.toCategory(),
      date: date,
      amount: amount,
    );
  }

  static ExpenseDocument fromExpense(Expense expense) {
    return ExpenseDocument(
      expenseId: expense.expenseId,
      category: CategoryDocument.fromCategory(expense.category),
      date: expense.date,
      amount: expense.amount,
    );
  }
}
