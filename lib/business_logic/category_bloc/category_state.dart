part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CreateCategoryFailure extends CategoryState {}

final class CreateCategoryLoading extends CategoryState {}

final class CreateCategorySuccess extends CategoryState {}

final class GetCategoriesFailure extends CategoryState {}

final class GetCategoriesLoading extends CategoryState {}

final class GetCategoriesSuccess extends CategoryState {
  final List<Category> categories;

  const GetCategoriesSuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}
