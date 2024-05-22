import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_repository/src/entities/entities.dart';

import '../models/models.dart';

class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime date;
  int amount;

  ExpenseEntity(
      {required this.expenseId,
      required this.category,
      required this.date,
      required this.amount});

  Map<String, Object> toDocument() {
    return {
      'expenseId': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> document) {
    return ExpenseEntity(
        expenseId: document['expenseId'] as String,
        category: Category.fromEntity(
            CategoryEntity.fromDocument(document['category'])),
        date: (document['date'] as Timestamp).toDate(),
        amount: document['amount'] as int);
  }
}
