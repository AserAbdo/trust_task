import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit({required this.getCategoriesUseCase})
    : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(CategoriesError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  void selectTab(int index) {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      emit(currentState.copyWith(selectedTabIndex: index));
    }
  }
}
