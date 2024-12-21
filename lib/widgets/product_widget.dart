import 'package:e_commerce_app/data.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:e_commerce_app/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: BlocBuilder<EcommerceBloc, EcommerceState>(
        builder: (context, state) {
          if (state.homeStatus == HomeScreenStatus.loading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.green,
            ));
          }
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .60,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return _buildCardProduct(context, size, product: product);
              });
        },
      ),
    );
  }

  _buildCardProduct(
    BuildContext context,
    Size size, {
    required ProductModel product,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          height: 155,
          decoration: BoxDecoration(
            color: AppColors.greyBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(product.imageUrl),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          product.title,
          maxLines: 2,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "\$${product.price}",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        AppPrimaryButton(
          onTap: () {
            context.read<EcommerceBloc>().add(AddToCartEvent(product: product));
          },
          text: "Add to cart",
          height: 30,
        )
      ],
    );
  }
}
