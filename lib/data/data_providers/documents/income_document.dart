import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/models.dart';

class IncomeDocument {
  String incomeId;
  DateTime date;
  double amount;

  IncomeDocument({
    required this.incomeId,
    required this.date,
    required this.amount,
  });

  Map<String, Object> toDocument() {
    return {
      'incomeId': incomeId,
      'date': date,
      'amount': amount,
    };
  }

  static IncomeDocument fromDocument(Map<String, dynamic> document) {
    return IncomeDocument(
      incomeId: document['incomeId'] as String,
      date: (document['date'] as Timestamp).toDate(),
      amount: (document['amount'] as num).toDouble(),
    );
  }

  static IncomeDocument fromIncome(Income income) {
    return IncomeDocument(
      incomeId: income.incomeId,
      date: income.date,
      amount: income.amount,
    );
  }

  Income toIncome() {
    return Income(
      incomeId: incomeId,
      date: date,
      amount: amount,
    );
  }
}
