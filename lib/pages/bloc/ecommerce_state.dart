part of 'ecommerce_bloc.dart';

enum HomeScreenStatus { none, loading, success, error }

class EcommerceState extends Equatable {
  final List<ProductModel> products;
  final List<ProductModel> cartProducts;
  final HomeScreenStatus homeStatus;

  const EcommerceState({
    required this.products,
    required this.cartProducts,
    required this.homeStatus,
  });

  factory EcommerceState.initial() {
    return const EcommerceState(
      products: [],
      cartProducts: [],
      homeStatus: HomeScreenStatus.none,
    );
  }

  EcommerceState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? cartProducts,
    HomeScreenStatus? homeStatus,
  }) {
    return EcommerceState(
      products: products ?? this.products,
      cartProducts: cartProducts ?? this.cartProducts,
      homeStatus: homeStatus ?? this.homeStatus,
    );
  }

  @override
  List<Object> get props => [products, cartProducts, homeStatus];
}
