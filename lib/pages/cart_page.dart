import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EcommerceBloc, EcommerceState>(
      builder: (context, state) {
        return ListView.builder(
            itemCount: state.cartProducts.length,
            itemBuilder: (context, index) {
              if (state.cartProducts.isEmpty) {
                return const Center(child: Text('No products in cart'));
              }
              final product = state.cartProducts[index];
              return _itemCart(size, product);
            });
      },
    );
  }

  Widget _itemCart(Size size, ProductModel product) {
    String price = (product.price * product.quantity).toString();
    return Container(
      width: size.width,
      height: size.height * 0.15,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.greyBackground,
            ),
            child: Image(
              image: NetworkImage(product.imageUrl),
              width: size.width * 0.25,
            ),
          ),
          Container(
            width: size.width * 0.6,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.greyBackground, width: 2.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.title,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "\$$price",
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle)),
                    Text(product.quantity.toString()),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.add_circle)),
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
