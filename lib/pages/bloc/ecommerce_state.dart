part of 'ecommerce_bloc.dart';

enum HomeScreenStatus { none, loading, success, error }

class EcommerceState extends Equatable {
  final List<ProductModel> products;
  final List<ProductModel> cartProducts;
  final HomeScreenStatus homeStatus;
  final List<ProductModel> filteredProducts;
  final List<ProductModel> favorites;
  final String filter;

  const EcommerceState({
    required this.products,
    required this.cartProducts,
    required this.homeStatus,
    required this.filteredProducts,
    required this.favorites,
    required this.filter,
  });

  factory EcommerceState.initial() {
    return const EcommerceState(
      products: [],
      cartProducts: [],
      homeStatus: HomeScreenStatus.none,
      filteredProducts: [],
      favorites: [],
      filter: 'all',
    );
  }

  EcommerceState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? cartProducts,
    HomeScreenStatus? homeStatus,
    List<ProductModel>? filteredProducts,
    List<ProductModel>? favorites,
    String? filter,
  }) {
    return EcommerceState(
      products: products ?? this.products,
      cartProducts: cartProducts ?? this.cartProducts,
      homeStatus: homeStatus ?? this.homeStatus,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      favorites: favorites ?? this.favorites,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props =>
      [products, cartProducts, homeStatus, filteredProducts, favorites, filter];
}
