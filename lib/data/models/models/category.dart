class Category {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  Category(
      {required this.categoryId,
      required this.name,
      required this.icon,
      required this.color,
      this.totalExpenses = 0});

  static final empty = Category(
    categoryId: '',
    name: '',
    icon: '',
    color: 0,
    totalExpenses: 0,
  );
}
