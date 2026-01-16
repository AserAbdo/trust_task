import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final int selectedTabIndex;

  const CategoriesLoaded({required this.categories, this.selectedTabIndex = 0});

  CategoriesLoaded copyWith({
    List<Category>? categories,
    int? selectedTabIndex,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [categories, selectedTabIndex];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
