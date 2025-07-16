part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductModel> products;
  final List<ProductModel> searchedProducts;
  final List<String> categories;
  final List<CartModel>? cart;
  final List<CartModel>? order;
  final bool isLoading;
  final String? searchQuery;
  final String? error;

  const ProductState({
    required this.products,
    required this.searchedProducts,
    required this.isLoading,
    this.order,
    this.cart,
    this.error,
    this.searchQuery,
    required this.categories,
  });

  const ProductState.loading()
    : this(
        isLoading: true,
        products: const [],
        searchedProducts: const [],
        categories: const [],
        cart: const [],
        order: const [],
        searchQuery: null,
        error: null,
      );

  const ProductState.loaded({
    List<ProductModel>? products,
    String? searchQuery,
    List<String>? categories,
    List<CartModel>? cart,
    List<CartModel>? order,
  }) : this(
         products: products ?? const [],
         searchedProducts: products ?? const [],
         isLoading: false,
         searchQuery: searchQuery,
         categories: categories ?? const [],
         cart: cart ?? const [],
         order: order ?? const [],
       );

  const ProductState.error(String message)
    : this(
        products: const [],
        searchedProducts: const [],
        isLoading: false,
        error: message,
        categories: const [],
        cart: const [],
        searchQuery: null,
        order: const [],
      );

  @override
  List<Object?> get props => [
    products,
    searchedProducts,
    isLoading,
    error,
    cart,
    searchQuery,
    categories,
    order,
  ];
}
