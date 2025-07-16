import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  ProductBloc(this.repository) : super(const ProductState.loading()) {
    on<ProductRequested>(_onRequested);
    on<ProductSearched>(_onSearched);
    on<ProductCategoriesRequested>(_onCategoriesRequested);
    on<ProductCategorySelected>(_onCategorySelected);
    on<ProductAddedToCart>(_onProductAddedToCart);
    on<FetchCart>(_onFetchCart);
    on<OrderProducts>(_onOrderProducts);
    on<FetchOrder>(_onFetchOrder);
  }

  Future<void> _onRequested(
    ProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final products = await repository.fetchProducts();
      final cart = await repository.fetchCart();
      emit(ProductState.loaded(products: products, cart: cart));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onSearched(
    ProductSearched event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await repository.searchProducts(event.searchQuery);
      emit(
        ProductState.loaded(products: products, searchQuery: event.searchQuery),
      );
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onCategoriesRequested(
    ProductCategoriesRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final categories = await repository.fetchCategories();
      emit(ProductState.loaded(categories: categories));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onCategorySelected(
    ProductCategorySelected event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());
    try {
      final products = await repository.fetchProductsByCategory(event.category);
      emit(ProductState.loaded(products: products));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onProductAddedToCart(
    ProductAddedToCart event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await repository.addToCart(event.cart);
      emit(ProductState.loaded(cart: event.cart));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onFetchCart(FetchCart event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    try {
      final cart = await repository.fetchCart();
      emit(ProductState.loaded(cart: cart));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> _onOrderProducts(
    OrderProducts event,
    Emitter<ProductState> emit,
  ) async {
    await repository.orderProducts(event.cart);
    await repository.addToCart([]);
    emit(ProductState.loaded(order: event.cart,cart: []));
  }

  Future<void> _onFetchOrder(FetchOrder event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    try {
      final order = await repository.fetchOrder();
      emit(ProductState.loaded(cart: order));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }
}
