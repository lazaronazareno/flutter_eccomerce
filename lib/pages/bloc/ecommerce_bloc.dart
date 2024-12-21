import 'package:e_commerce_app/data.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

class EcommerceBloc extends Bloc<EcommerceEvent, EcommerceState> {
  EcommerceBloc() : super(EcommerceState.initial()) {
    on<FetchProductsEvent>(_onFetchProductsEvent);
    on<AddToCartEvent>(_onAddtoCartEvent);
    on<UpdateCartItemEvent>(_onUpdateCartItemEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
  }

  void _onFetchProductsEvent(
      FetchProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeStatus: HomeScreenStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    final products = productsData.map((product) {
      return ProductModel(
        id: product["id"].toString(),
        description: product["description"],
        title: product["title"],
        price: (product["price"]),
        imageUrl: product["imageUrl"],
        type: product["type"],
      );
    }).toList();

    emit(
      state.copyWith(products: products, homeStatus: HomeScreenStatus.success),
    );
  }

  void _onAddtoCartEvent(AddToCartEvent event, Emitter<EcommerceState> emit) {
    //se verifica si el producto ya existe en el carrito
    final exist = state.cartProducts.firstWhere(
      (item) => item.id == event.product.id,
      orElse: () => event.product.copyWith(quantity: 0),
    );

    //si el producto ya existe en la lista, no se agrega como producto nuevo, sino que se actualiza la cantidad
    final updatedCart = state.cartProducts.map((item) {
      if (item.id == event.product.id) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    //se agregar un producto que no exista(nuevo) en el carrito
    if (exist.quantity == 0) {
      updatedCart.add(event.product.copyWith(quantity: 1));
    }

    emit(state.copyWith(cartProducts: updatedCart));
  }

  //de tarea hacer estas funcionalidades, y tambien que no permita menos de 1

  void _onUpdateCartItemEvent(
      UpdateCartItemEvent event, Emitter<EcommerceState> emit) {}
  void _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) {}
}