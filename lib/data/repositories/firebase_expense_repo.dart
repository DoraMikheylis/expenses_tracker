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

  String? _getUid() {
    return _auth.currentUser?.uid;
  }

  @override
  Future<void> createCategory(Category category) async {
    final uid = _getUid();
    if (uid != null) {
      final categoryDoc = CategoryDocument.fromCategory(category);
      await _collection(uid, CollectionTypes.categories)
          .doc(categoryDoc.categoryId)
          .set(categoryDoc.toDocument());
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final uid = _getUid();
    if (uid == null) {
      return [];
    }

    final snapshot = await _collection(uid, CollectionTypes.categories).get();
    return snapshot.docs
        .map((e) => CategoryDocument.fromDocument(e.data()).toCategory())
        .toList();
  }

  @override
  Future<Category> getCategoryById(String categoryId) async {
    final uid = _getUid();
    if (uid == null) {
      return Category.createEmpty();
    }

    final document = await _collection(uid, CollectionTypes.categories)
        .doc(categoryId)
        .get();

    if (document.exists && document.data() != null) {
      return CategoryDocument.fromDocument(document.data()!).toCategory();
    }

    return Category.createEmpty();
  }

  @override
  Future<void> deleteCategory(Category category) async {
    final uid = _getUid();
    if (uid != null) {
      CategoryDocument categoryDocument =
          CategoryDocument.fromCategory(category);

      await _collection(uid, CollectionTypes.categories)
          .doc(categoryDocument.categoryId)
          .delete();
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    final uid = _getUid();
    if (uid != null) {
      final expenseDoc = ExpenseDocument.fromExpense(expense);
      await _collection(uid, CollectionTypes.expenses)
          .doc(expenseDoc.expenseId)
          .set(expenseDoc.toDocument());
    }
  }

  @override
  Future<List<Expense>> getExpenses({int? limit}) async {
    final uid = _getUid();
    if (uid == null) {
      return [];
    }

    Query<Map<String, dynamic>> query =
        _collection(uid, CollectionTypes.expenses);
    if (limit != null) query = query.limit(limit);

    final snapshot = await query.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((e) => ExpenseDocument.fromDocument(e.data()).toExpense())
        .toList();
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    final uid = _getUid();
    if (uid != null) {
      await _collection(uid, CollectionTypes.expenses).doc(expenseId).delete();
    }
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId,
      {int? limit}) async {
    final uid = _getUid();
    if (uid == null) return [];

    Query<Map<String, dynamic>> query =
        _collection(uid, CollectionTypes.expenses);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExpenseDocument.fromDocument(doc.data()).toExpense())
        .toList();
  }

  @override
  Future<Map<String, List<Expense>>> getExpensesGroupedByCategory(
      {DateTime? date}) async {
    final uid = _getUid();
    if (uid == null) return {};

    final categories = await getCategories();
    final expenses = await _getExpensesByDate(uid, date);

    return _groupExpensesByCategory(expenses, categories);
  }

  Future<List<Expense>> _getExpensesByDate(String uid, DateTime? date) async {
    Query<Map<String, dynamic>> query =
        _collection(uid, CollectionTypes.expenses);

    if (date != null) {
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);
      query = query
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: true);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ExpenseDocument.fromDocument(doc.data()).toExpense())
        .toList();
  }

  Map<String, List<Expense>> _groupExpensesByCategory(
      List<Expense> allExpenses, List<Category> categories) {
    Map<String, List<Expense>> groupedExpenses = {};

    for (var category in categories) {
      final categoryExpenses = allExpenses
          .where(
              (expense) => expense.category.categoryId == category.categoryId)
          .toList();
      groupedExpenses[category.categoryId] = categoryExpenses;
    }

    return groupedExpenses;
  }

  @override
  Future<void> createIncome(Income income) async {
    final uid = _getUid();
    if (uid != null) {
      IncomeDocument incomeDocument = IncomeDocument.fromIncome(income);
      await _collection(uid, CollectionTypes.incomes)
          .doc(incomeDocument.incomeId)
          .set(incomeDocument.toDocument());
    }
  }

  @override
  Future<List<Income>> getIncomes() async {
    final uid = _getUid();
    if (uid != null) {
      return _collection(uid, CollectionTypes.incomes).get().then((value) =>
          value.docs
              .map((e) => IncomeDocument.fromDocument(e.data()).toIncome())
              .toList());
    }
    return [];
  }
}
