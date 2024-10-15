import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'expense_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum CollectionTypes { categories, expenses, incomes }

class FirebaseExpenseRepo implements ExpenseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _collection(
      String uid, CollectionTypes type) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(type.name);
  }

  String? getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid;
  }

  @override
  Future<void> createCategory(Category category) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      CategoryDocument categoryDocument =
          CategoryDocument.fromCategory(category);
      try {
        await _collection(uid, CollectionTypes.categories)
            .doc(categoryDocument.categoryId)
            .set(categoryDocument.toDocument());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final uid = getCurrentUserId();
    if (uid != null) {
      try {
        return await _collection(uid, CollectionTypes.categories).get().then(
            (value) => value.docs
                .map(
                    (e) => CategoryDocument.fromDocument(e.data()).toCategory())
                .toList());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
    return [];
  }

  @override
  Future<void> deleteCategory(Category category) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      CategoryDocument categoryDocument =
          CategoryDocument.fromCategory(category);
      try {
        await _collection(uid, CollectionTypes.categories)
            .doc(categoryDocument.categoryId)
            .delete();
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      ExpenseDocument expenseDocument = ExpenseDocument.fromExpense(expense);
      try {
        await _collection(uid, CollectionTypes.expenses)
            .doc(expenseDocument.expenseId)
            .set(expenseDocument.toDocument());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  @override
  Future<List<Expense>> getExpenses({int? limit}) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      try {
        Query<Map<String, dynamic>> query =
            _collection(uid, CollectionTypes.expenses);
        if (limit != null) {
          query = query.limit(limit);
        }
        return await query.orderBy('date', descending: true).get().then(
            (value) => value.docs
                .map((e) => ExpenseDocument.fromDocument(e.data()).toExpense())
                .toList());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
    return [];
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      try {
        await _collection(uid, CollectionTypes.expenses)
            .doc(expenseId)
            .delete();
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId,
      {int? limit}) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      try {
        Query<Map<String, dynamic>> query =
            _collection(uid, CollectionTypes.expenses);
        if (limit != null) {
          query = query.limit(limit);
        }
        return await query
            .where('categoryId', isEqualTo: categoryId)
            .orderBy('date', descending: true)
            .get()
            .then((value) => value.docs
                .map((e) => ExpenseDocument.fromDocument(e.data()).toExpense())
                .toList());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
    return [];
  }

  @override
  Future<Map<Category, List<Expense>>> getExpensesGroupedByCategory(
      {DateTime? date}) async {
    final uid = getCurrentUserId();
    if (uid == null) return {};

    try {
      final categories = await getCategories();
      final allExpenses = await _getExpensesFromFirestore(uid, date);

      final groupedExpenses = _groupExpensesByCategory(allExpenses, categories);

      return _sortCategoriesByExpenseSum(groupedExpenses);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Expense>> _getExpensesFromFirestore(
      String uid, DateTime? date) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot;

    if (date != null) {
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);

      querySnapshot = await _collection(uid, CollectionTypes.expenses)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: true)
          .get();
    } else {
      querySnapshot = await _collection(uid, CollectionTypes.expenses).get();
    }

    return querySnapshot.docs
        .map((doc) => ExpenseDocument.fromDocument(doc.data()).toExpense())
        .toList();
  }

  Map<Category, List<Expense>> _groupExpensesByCategory(
      List<Expense> allExpenses, List<Category> categories) {
    Map<Category, List<Expense>> groupedExpenses = {};

    for (var category in categories) {
      final categoryExpenses = allExpenses
          .where(
              (expense) => expense.category.categoryId == category.categoryId)
          .toList();
      groupedExpenses[category] = categoryExpenses;
    }

    return groupedExpenses;
  }

  Map<Category, List<Expense>> _sortCategoriesByExpenseSum(
      Map<Category, List<Expense>> groupedExpenses) {
    var sortedEntries = groupedExpenses.entries.toList()
      ..sort((a, b) {
        double sumA = _calculateTotalExpense(a.value);
        double sumB = _calculateTotalExpense(b.value);
        return sumB.compareTo(sumA);
      });

    return {for (var entry in sortedEntries) entry.key: entry.value};
  }

  double _calculateTotalExpense(List<Expense> expenses) {
    return expenses.fold(0.0, (amount, expense) => amount + expense.amount);
  }

  // @override
  // Future<Map<Category, List<Expense>>> getExpensesGroupedByCategory(
  //     {DateTime? date}) async {
  //   final uid = getCurrentUserId();
  //   if (uid != null) {
  //     try {
  //       final categories = await getCategories();
  //       Map<Category, List<Expense>> groupedExpenses = {};
  //       late final QuerySnapshot<Map<String, dynamic>> querySnapshot;

  //       if (date != null) {
  //         DateTime startOfMonth = DateTime(date.year, date.month, 1);
  //         DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);

  //         querySnapshot = await expenseCollection(uid)
  //             .where('date', isGreaterThanOrEqualTo: startOfMonth)
  //             .where('date', isLessThanOrEqualTo: endOfMonth)
  //             .get();
  //       } else {
  //         querySnapshot = await expenseCollection(uid).get();
  //       }
  //       final allExpenses = querySnapshot.docs
  //           .map((doc) => ExpenseDocument.fromDocument(doc.data()).toExpense())
  //           .toList();

  //       for (var category in categories) {
  //         final categoryExpenses = allExpenses
  //             .where((expense) =>
  //                 expense.category.categoryId == category.categoryId)
  //             .toList();
  //         groupedExpenses[category] = categoryExpenses;
  //       }

  //       return groupedExpenses;
  //     } catch (e) {
  //       log(e.toString());
  //       rethrow;
  //     }
  //   }
  //   return {};
  // }

  @override
  Future<void> createIncome(Income income) async {
    final uid = getCurrentUserId();
    if (uid != null) {
      IncomeDocument incomeDocument = IncomeDocument.fromIncome(income);
      try {
        await _collection(uid, CollectionTypes.incomes)
            .doc(incomeDocument.incomeId)
            .set(incomeDocument.toDocument());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
  }

  @override
  Future<List<Income>> getIncomes() async {
    final uid = getCurrentUserId();
    if (uid != null) {
      try {
        return await _collection(uid, CollectionTypes.incomes).get().then(
            (value) => value.docs
                .map((e) => IncomeDocument.fromDocument(e.data()).toIncome())
                .toList());
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
    return [];
  }
}
