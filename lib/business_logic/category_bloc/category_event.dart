part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategoryEvent extends CategoryEvent {
  final Category category;
  const CreateCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class GetCategoriesEvent extends CategoryEvent {
  const GetCategoriesEvent();
}
