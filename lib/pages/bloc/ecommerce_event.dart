part of 'ecommerce_bloc.dart';

sealed class EcommerceEvent extends Equatable {
  const EcommerceEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends EcommerceEvent {}

class AddToCartEvent extends EcommerceEvent {
  final ProductModel product;

  const AddToCartEvent({required this.product});
}

class UpdateCartItemEvent extends EcommerceEvent {
  final ProductModel product;

  const UpdateCartItemEvent({required this.product});
}

class RemoveCartItemEvent extends EcommerceEvent {
  final ProductModel product;

  const RemoveCartItemEvent({required this.product});
}

class CheckoutCartEvent extends EcommerceEvent {}
