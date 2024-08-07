import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

createCategory({
  required BuildContext context,
  required String categoryName,
  required String categoryIcon,
  required int categoryColor,
}) {
  Category category = Category.empty;
  category.categoryId = const Uuid().v1();

  category.name = categoryName;
  category.icon = categoryIcon;
  category.color = categoryColor;

  context.read<CategoryBloc>().add(CreateCategoryEvent(category));
}
