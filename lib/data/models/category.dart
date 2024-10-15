class Category {
  String categoryId;
  String name;
  String icon;
  int color;

  Category({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
  });

  static Category createEmpty() {
    return Category(
      categoryId: '',
      name: '',
      icon: '',
      color: 0,
    );
  }
}
