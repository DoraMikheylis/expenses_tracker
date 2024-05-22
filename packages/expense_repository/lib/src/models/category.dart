import '../entities/entities.dart';

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

  CategoryEntity toEntity() {
    return CategoryEntity(
        categoryId: categoryId,
        name: name,
        icon: icon,
        color: color,
        totalExpenses: totalExpenses);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
        categoryId: entity.categoryId,
        name: entity.name,
        icon: entity.icon,
        color: entity.color,
        totalExpenses: entity.totalExpenses);
  }
}
