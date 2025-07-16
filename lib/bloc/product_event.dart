part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductRequested extends ProductEvent {
  const ProductRequested();
}

class ProductSearched extends ProductEvent {
  final String searchQuery;
  const ProductSearched(this.searchQuery);
}

class ProductCategoriesRequested extends ProductEvent {
  const ProductCategoriesRequested();
}

class ProductCategorySelected extends ProductEvent {
  final String category;
  const ProductCategorySelected(this.category);
}

class ProductAddedToCart extends ProductEvent {
  final List<CartModel> cart;
  const ProductAddedToCart(this.cart);
}

class FetchCart extends ProductEvent {
  const FetchCart();
}

class OrderProducts extends ProductEvent {
  final List<CartModel> cart;
  const OrderProducts(this.cart);
}

class FetchOrder extends ProductEvent {
  const FetchOrder();
}
