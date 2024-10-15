import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ExpenseRepository expenseRepository;

  CategoryBloc(this.expenseRepository) : super(CategoryInitial()) {
    on<CreateCategoryEvent>((event, emit) async {
      emit(CreateCategoryLoading());
      try {
        await expenseRepository.createCategory(event.category);
        emit(CreateCategorySuccess());
      } catch (e) {
        emit(CreateCategoryFailure());
      }
    });

    on<GetCategoriesEvent>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        List<Category> categories = await expenseRepository.getCategories();
        emit(GetCategoriesSuccess(categories: categories));
      } catch (e) {
        emit(GetCategoriesFailure());
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      emit(DeleteCategoryLoading());
      try {
        await expenseRepository.deleteCategory(event.category);
        emit(DeleteCategorySuccess());
      } catch (e) {
        emit(DeleteCategoryFailure());
      }
    });
  }
}
