import 'package:dio/dio.dart';
import 'package:e_commerce_app/data.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

const baseUrl =
    "https://lazaro-portfolio-default-rtdb.firebaseio.com/ecommerce-flutter.json";
const cartUrl =
    "https://lazaro-portfolio-default-rtdb.firebaseio.com/ecommerce-flutter-cart";

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
    final data = response.data as Map<String, dynamic>?;

    final responseCart = await dio.get('$cartUrl.json');
    final dataCart = responseCart.data as Map<String, dynamic>?;

    if (data == null) {
      emit(state.copyWith(homeStatus: HomeScreenStatus.success, products: []));
      return;
    }

    final productsData = data.entries.map((item) {
      final product = item.value;
      return ProductModel(
          title: product["description"],
          price: product["price"],
          id: product["id"],
          imageUrl: product["image_url"],
          description: product["description"] ?? "",
          type: product["product"] ?? "all");
    }).toList();

    List<ProductModel> cartListItems = [];

    if (dataCart != null) {
      cartListItems = dataCart.entries.map((item) {
        final product = item.value;

        return ProductModel(
            title: product["description"],
            price: product["price"],
            id: product["id"],
            imageUrl: product["image_url"],
            description: product["description"] ?? "",
            type: product["product"] ?? "all");
      }).toList();
    }

    emit(
      state.copyWith(
        products: productsData,
        homeStatus: HomeScreenStatus.success,
        filteredProducts: productsData,
        cartProducts: cartListItems,
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

  //este lo estoy usando para actualizar el carrito pero restando
  void _onUpdateCartItemEvent(
      UpdateCartItemEvent event, Emitter<EcommerceState> emit) async {
    final ProductModel product = event.product;

    if (product.quantity == 1) {
      await dio.delete("$cartUrl/${product.id}.json");

      final updatedCart =
          state.cartProducts.where((item) => item.id != product.id).toList();

      return emit(state.copyWith(cartProducts: updatedCart));
    }

    final newProductQuantity = product.quantity - 1;

    await dio.patch(
      "$cartUrl/${product.id}.json",
      data: {"quantity": newProductQuantity},
    );

    final updatedCart = [...state.cartProducts];
    final index = updatedCart.indexWhere((item) => item.id == product.id);
    updatedCart[index] = product.copyWith(quantity: newProductQuantity);

    emit(state.copyWith(cartProducts: updatedCart));
  }

  void _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) async {
    final ProductModel product = event.product;

    await dio.delete("$cartUrl/${product.id}.json");

    final updatedCart =
        state.cartProducts.where((item) => item.id != product.id).toList();

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
      if (event.filter == 'All') {
        return true;
      }
      return product.type == event.filter;
    }).toList();

    print(filteredProducts);

    emit(state.copyWith(
        filteredProducts: filteredProducts, filter: event.filter));
  }

  void _onLoadCartItemsEvent(
      LoadCartItemsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeStatus: HomeScreenStatus.loading));
    final response = await dio.get("$cartUrl.json");
    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(state.copyWith(cartProducts: []));
      return;
    }

    final cartItems = data.entries.map((item) {
      final product1 = item.value;

      return ProductModel(
        title: product1["description"],
        price: product1["price"],
        id: product1["id"],
        imageUrl: product1["image_url"],
        description: product1["description"] ?? "",
        type: product1["product"] ?? "all",
        quantity: product1["quantity"] ?? 1,
      );
    }).toList();

    emit(state.copyWith(
        cartProducts: cartItems, homeStatus: HomeScreenStatus.success));
  }

  void _onPostItemToCartEvent(
      PostItemToCartEvent event, Emitter<EcommerceState> emit) async {
    //generar un uuid para el producto
    //String id = uuid.v1();

    final ProductModel product = event.product;

    //verificar si el producto ya existe en el carrito: -1 si no lo encontro, otro numero si está
    final existItemIndex =
        state.cartProducts.indexWhere((item) => item.id == product.id);

    if (existItemIndex >= 0) {
      final productItem = state.cartProducts[existItemIndex];
      final newProductQuantity = productItem.quantity + 1;

      await dio.patch(
        "$cartUrl/${product.id}.json",
        data: {"quantity": newProductQuantity},
      );

      final updatedCart = [...state.cartProducts];
      updatedCart[existItemIndex] =
          productItem.copyWith(quantity: newProductQuantity);

      emit(state.copyWith(cartProducts: updatedCart));
    } else {
      final url = "$cartUrl/${product.id}.json";
      await dio.put(
        url,
        data: {
          "id": product.id,
          "description": product.title,
          "image_url": product.imageUrl,
          "price": product.price,
          "product": product.type,
          "quantity": 1,
        },
      );

      final updatedCart = [...state.cartProducts, product];

      emit(state.copyWith(cartProducts: updatedCart));
    }
  }
}
