import 'package:dio/dio.dart';
import 'package:e_commerce_app/data.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

const baseUrl = "https://demoluisfelipe.firebaseio.com/adl_ecommerce.json";
const cartUrl = "https://demoluisfelipe.firebaseio.com/adl_ecommerce_cart_lvs";

class EcommerceBloc extends Bloc<EcommerceEvent, EcommerceState> {
  var uuid = const Uuid();
  var dio = Dio();

  EcommerceBloc() : super(EcommerceState.initial()) {
    on<FetchProductsEvent>(_onFetchProductsEvent);
    on<AddToCartEvent>(_onAddtoCartEvent);
    on<UpdateCartItemEvent>(_onUpdateCartItemEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
    on<CheckoutCartEvent>(_onCheckoutCartEvent);
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent);
    on<ChangeFilterEvent>(_onChangeFilterEvent);
    on<LoadCartItemsEvent>(_onLoadCartItemsEvent);
    on<PostItemToCartEvent>(_onPostItemToCartEvent);
  }

/*   void _onFetchProductsEvent(
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

    final filteredProducts = products.where((product) {
      if (state.filter == 'all') {
        return true;
      }
      return product.type == state.filter;
    }).toList();

    emit(
      state.copyWith(
          products: products,
          homeStatus: HomeScreenStatus.success,
          filteredProducts: filteredProducts),
    );
  } */

  void _onFetchProductsEvent(
      FetchProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeStatus: HomeScreenStatus.loading));

    final response = await dio.get(baseUrl);

    final productsData =
        (response.data as Map<String, dynamic>).entries.map((item) {
      final product = item.value;
      return ProductModel(
          title: product["description"],
          price: product["price"],
          id: item.key,
          imageUrl: product["image_url"],
          description: product["description"] ?? "",
          type: product["product"] ?? "all");
    }).toList();

    /* final products = productsData.map((product) {
      return ProductModel(
        id: product["id"].toString(),
        description: product["description"],
        title: product["title"],
        price: (product["price"]),
        imageUrl: product["imageUrl"],
        type: product["type"],
      );
    }).toList(); */

    final filteredProducts = productsData.where((product) {
      if (state.filter == 'all') {
        return true;
      }
      return product.type == state.filter;
    }).toList();

    emit(
      state.copyWith(
        products: productsData,
        homeStatus: HomeScreenStatus.success,
        filteredProducts: productsData,
      ),
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

  //este lo estoy usando para actualizar el carrito pero restando
  //cambiar nombre
  void _onUpdateCartItemEvent(
      UpdateCartItemEvent event, Emitter<EcommerceState> emit) {
    final quantityInitial = event.product.quantity;

    //actualiza el carrito restando la cantidad de a 1
    final updatedCart = state.cartProducts.map((item) {
      if (item.id == event.product.id) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();

    //si la cantidad del producto inicial era 1, se elimina el producto del carrito
    if (quantityInitial == 1) {
      updatedCart.removeWhere((item) => item.id == event.product.id);
    }

    emit(state.copyWith(cartProducts: updatedCart));
  }

  void _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) {
    final updatedCart = state.cartProducts
        .where((item) => item.id != event.product.id)
        .toList();

    emit(state.copyWith(cartProducts: updatedCart));
  }

  void _onCheckoutCartEvent(
      CheckoutCartEvent event, Emitter<EcommerceState> emit) {
    if (state.cartProducts.isEmpty) {
      return;
    }
    emit(state.copyWith(cartProducts: List<ProductModel>.empty()));
  }

  void _onToggleFavoriteEvent(
      ToggleFavoriteEvent event, Emitter<EcommerceState> emit) {
    final isFavorite = state.favorites.contains(event.productId);

    final currentProducts = state.favorites.map((item) {
      if (item.id == event.productId.id) {
        return item.copyWith(isFavorite: !isFavorite);
      }
      return item;
    }).toList();

    final favoriteProducts =
        currentProducts.where((product) => product.isFavorite).toList();

    final filteredProducts = currentProducts.where((product) {
      if (state.filter == 'all') {
        return true;
      }
      return product.type == state.filter;
    }).toList();

    emit(state.copyWith(
        products: currentProducts,
        favorites: favoriteProducts,
        filteredProducts: filteredProducts));
  }

  void _onChangeFilterEvent(
      ChangeFilterEvent event, Emitter<EcommerceState> emit) {
    final filteredProducts = state.products.where((product) {
      if (event.filter == 'all') {
        return true;
      }
      return product.type == event.filter;
    }).toList();

    emit(state.copyWith(
        filteredProducts: filteredProducts, filter: event.filter));
  }

  void _onLoadCartItemsEvent(
      LoadCartItemsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeStatus: HomeScreenStatus.loading));

    List<ProductModel> cartItems = [];

    final response = await dio.get("$cartUrl.json");
    print(response);
    try {
      cartItems = (response.data as Map<String, dynamic>).entries.map((item) {
        final product1 = item.value;
        final product2 = product1.entries.first.value;
        print(product2);
        return ProductModel(
            title: product2["description"],
            price: product2["price"],
            id: product2["id"],
            imageUrl: product2["image_url"],
            description: product2["description"] ?? "",
            type: product2["product"] ?? "all");
      }).toList();
    } catch (e) {
      print(e);
    }

    print(cartItems);

    emit(state.copyWith(
        cartProducts: cartItems, homeStatus: HomeScreenStatus.success));
  }

  void _onPostItemToCartEvent(
      PostItemToCartEvent event, Emitter<EcommerceState> emit) async {
    //generar un uuid para el producto
    final id = uuid.v1();
    final url = "$cartUrl/$id.json";
    print(url);
    final response = await dio.post(
      url,
      data: {
        "id": id,
        "description": event.product.description,
        "image_url": event.product.imageUrl,
        "price": event.product.price,
        "product": event.product.type
      },
    );

    print(response.data);

    emit(state.copyWith(cartProducts: state.cartProducts));
  }
}
