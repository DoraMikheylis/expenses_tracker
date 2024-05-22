class CategoryEntity {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  CategoryEntity(
      {required this.categoryId,
      required this.name,
      required this.icon,
      required this.color,
      this.totalExpenses = 0});

  Map<String, Object> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'icon': icon,
      'color': color,
      'totalExpenses': totalExpenses
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> document) {
    return CategoryEntity(
        categoryId: document['categoryId'] as String,
        name: document['name'] as String,
        icon: document['icon'] as String,
        color: document['color'] as int,
        totalExpenses: document['totalExpenses'] as int);
  }
}
