import 'dart:developer';

import 'expense_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(Category category) async {
    CategoryDocument categoryDocument = CategoryDocument.fromCategory(category);
    try {
      await categoryCollection
          .doc(categoryDocument.categoryId)
          .set(categoryDocument.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await categoryCollection.get().then((value) => value.docs
          .map((e) => CategoryDocument.fromDocument(e.data()).toCategory())
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    ExpenseDocument expenseDocument = ExpenseDocument.fromExpense(expense);
    try {
      await expenseCollection
          .doc(expenseDocument.expenseId)
          .set(expenseDocument.toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpense() async {
    try {
      return await expenseCollection.get().then((value) => value.docs
          .map((e) => ExpenseDocument.fromDocument(e.data()).toExpense())
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
