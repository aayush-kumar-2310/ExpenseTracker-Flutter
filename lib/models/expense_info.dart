class Expense {
  final int id;
  final int expNo;
  final String title;
  final String amount;
  final String dateTime;
  final String category;

  Expense({
    required this.id,
    required this.expNo,
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.category,
  });
}

List<Expense> listOfExpense = [];
