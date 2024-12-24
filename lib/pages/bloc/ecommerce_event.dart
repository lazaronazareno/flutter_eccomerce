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

class ToggleFavoriteEvent extends EcommerceEvent {
  final ProductModel productId;

  const ToggleFavoriteEvent({required this.productId});
}

class ChangeFilterEvent extends EcommerceEvent {
  final String filter;

  const ChangeFilterEvent({required this.filter});
}

class LoadCartItemsEvent extends EcommerceEvent {}

class PostItemToCartEvent extends EcommerceEvent {
  final ProductModel product;

  const PostItemToCartEvent({required this.product});
}
