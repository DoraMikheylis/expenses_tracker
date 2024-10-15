class Income {
  String incomeId;

  DateTime date;
  double amount;

  Income({
    required this.incomeId,
    required this.date,
    required this.amount,
  });

  static Income createEmpty() {
    return Income(
      incomeId: '',
      date: DateTime.now(),
      amount: 0.0,
    );
  }
}
