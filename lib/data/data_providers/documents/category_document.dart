import 'package:expenses_tracker/data/models/models/category.dart';

class CategoryDocument {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  CategoryDocument(
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

  static CategoryDocument fromDocument(Map<String, dynamic> document) {
    return CategoryDocument(
        categoryId: document['categoryId'] as String,
        name: document['name'] as String,
        icon: document['icon'] as String,
        color: document['color'] as int,
        totalExpenses: document['totalExpenses'] as int);
  }

  static CategoryDocument fromCategory(Category category) {
    return CategoryDocument(
        categoryId: category.categoryId,
        name: category.name,
        icon: category.icon,
        color: category.color,
        totalExpenses: category.totalExpenses);
  }

  Category toCategory() {
    return Category(
        categoryId: categoryId,
        name: name,
        icon: icon,
        color: color,
        totalExpenses: totalExpenses);
  }
}
