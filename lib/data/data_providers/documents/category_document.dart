import 'package:expenses_tracker/data/models/category.dart';

class CategoryDocument {
  String categoryId;
  String name;
  String icon;
  int color;

  CategoryDocument({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, Object> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  static CategoryDocument fromDocument(Map<String, dynamic> document) {
    return CategoryDocument(
      categoryId: document['categoryId'] as String,
      name: document['name'] as String,
      icon: document['icon'] as String,
      color: document['color'] as int,
    );
  }

  static CategoryDocument fromCategory(Category category) {
    return CategoryDocument(
      categoryId: category.categoryId,
      name: category.name,
      icon: category.icon,
      color: category.color,
    );
  }

  Category toCategory() {
    return Category(
      categoryId: categoryId,
      name: name,
      icon: icon,
      color: color,
    );
  }
}
