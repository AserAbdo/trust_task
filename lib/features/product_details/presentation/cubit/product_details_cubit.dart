import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsCubit({required this.getProductDetailsUseCase})
    : super(ProductDetailsInitial());

  Future<void> loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    final result = await getProductDetailsUseCase(productId);

    result.fold(
      (failure) => emit(ProductDetailsError(message: failure.message)),
      (product) {
        final basePrice = double.tryParse(product.price) ?? 0;
        emit(
          ProductDetailsLoaded(
            product: product,
            quantity: 1,
            totalPrice: basePrice,
          ),
        );
      },
    );
  }

  void incrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailsLoaded) {
      final newQuantity = currentState.quantity + 1;
      _updateTotalPrice(currentState.copyWith(quantity: newQuantity));
    }
  }

  void decrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailsLoaded && currentState.quantity > 1) {
      final newQuantity = currentState.quantity - 1;
      _updateTotalPrice(currentState.copyWith(quantity: newQuantity));
    }
  }

  void toggleOption(int addonId, String optionLabel, bool isRadio) {
    final currentState = state;
    if (currentState is ProductDetailsLoaded) {
      final newSelectedOptions = Map<int, List<String>>.from(
        currentState.selectedOptions,
      );

      if (isRadio) {
        newSelectedOptions[addonId] = [optionLabel];
      } else {
        final currentOptions = List<String>.from(
          newSelectedOptions[addonId] ?? [],
        );
        if (currentOptions.contains(optionLabel)) {
          currentOptions.remove(optionLabel);
        } else {
          currentOptions.add(optionLabel);
        }
        newSelectedOptions[addonId] = currentOptions;
      }

      _updateTotalPrice(
        currentState.copyWith(selectedOptions: newSelectedOptions),
      );
    }
  }

  void _updateTotalPrice(ProductDetailsLoaded state) {
    final product = state.product;
    double basePrice = double.tryParse(product.price) ?? 0;
    double addonsPrice = 0;

    for (final addon in product.addons) {
      final selectedLabels = state.selectedOptions[addon.id] ?? [];
      for (final option in addon.options) {
        if (selectedLabels.contains(option.label)) {
          addonsPrice += double.tryParse(option.price) ?? 0;
        }
      }
    }

    final totalPrice = (basePrice + addonsPrice) * state.quantity;
    emit(state.copyWith(totalPrice: totalPrice));
  }

  List<Map<String, dynamic>> getSelectedAddonsForCart() {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return [];

    final List<Map<String, dynamic>> addons = [];
    final product = currentState.product;

    for (final addon in product.addons) {
      final selectedLabels = currentState.selectedOptions[addon.id] ?? [];
      for (final option in addon.options) {
        if (selectedLabels.contains(option.label)) {
          addons.add({
            'id': addon.id,
            'name': option.label,
            'price': option.price,
          });
        }
      }
    }

    return addons;
  }
}
