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
        4,
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Latest Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.greyBackground,
                        radius: 12,
                        child: IconButton(
                          onPressed: () {},
                          padding: const EdgeInsets.all(4),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: .60,
                    ),
                    itemCount: state.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.filteredProducts[index];
                      return _buildCardProduct(context, size, product: product);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildCardProduct(
    BuildContext context,
    Size size, {
    required ProductModel product,
  }) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.greyBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.network(product.imageUrl),
              ),
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
              style: TextStyle(
                  color: AppColors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            AppPrimaryButton(
              onTap: () {
                context
                    .read<EcommerceBloc>()
                    .add(PostItemToCartEvent(product: product));
              },
              text: "Add to cart",
              height: 30,
            ),
          ],
        ),
        Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              radius: 12,
              child: IconButton(
                padding: const EdgeInsets.all(4),
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
                  size: 14,
                ),
              ),
            ))
      ],
    );
  }
}
