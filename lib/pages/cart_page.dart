import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:e_commerce_app/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EcommerceBloc, EcommerceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            //esto es para que que no cambie de color el appbar
            scrolledUnderElevation: 0,
            leading: const Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Text(
                "Cart",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: AppColors.greyBackground,
                child: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.1,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                ),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 4, bottom: 16),
                child: TextField(
                  maxLines: null,
                  expands: false,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(0),
                    hintText: "92 High Street, London",
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    fillColor: AppColors.greyBackground,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),

                  //condicional
                  child: state.cartProducts.isEmpty
                      ? const Center(
                          child: Text('No products in cart'),
                        )
                      : ListView.builder(
                          itemCount: state.cartProducts.length,
                          itemBuilder: (context, index) {
                            final product = state.cartProducts[index];
                            return _itemCart(context, size, product);
                          },
                        ),
                ),
              ),
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: AppPrimaryButton(
                    onTap: () {
                      context.read<EcommerceBloc>().add(CheckoutCartEvent());
                    },
                    text: "Checkout",
                    height: 40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _itemCart(BuildContext context, Size size, ProductModel product) {
    String price = (product.price * product.quantity).toString();
    return Container(
      width: size.width,
      height: size.height * 0.21,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //icono
          SizedBox(
            width: size.width * 0.1,
            child: IconButton(
              onPressed: () {
                context
                    .read<EcommerceBloc>()
                    .add(RemoveCartItemEvent(product: product));
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          //imagen
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.greyBackground,
            ),
            child: Image(
              image: NetworkImage(product.imageUrl),
              width: size.width * 0.2,
            ),
          ),
          //description
          Container(
            width: size.width * 0.5,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.greyBackground, width: 2.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "\$$price",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.greyBackground,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          context
                              .read<EcommerceBloc>()
                              .add(UpdateCartItemEvent(product: product));
                        },
                        icon: Icon(
                          Icons.remove,
                          color: AppColors.black,
                        ),
                        iconSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.quantity.toString(),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.greyBackground,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          context
                              .read<EcommerceBloc>()
                              .add(AddToCartEvent(product: product));
                        },
                        icon: Icon(Icons.add, color: AppColors.black),
                        iconSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
