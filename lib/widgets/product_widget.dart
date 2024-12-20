import 'package:e_commerce_app/data.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:e_commerce_app/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

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
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .60,
          ),
          itemCount: productsData.length,
          itemBuilder: (context, index) {
            final product = productsData[index];
            return _buildCardProduct(size,
                title: product["title"],
                price: product["price"].toString(),
                productId: product["id"].toString(),
                imageUrl: product["imageUrl"]);
          }),
    );
  }

  _buildCardProduct(
    Size size, {
    required String title,
    required String price,
    required String productId,
    required String imageUrl,
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
          child: Image.network(imageUrl),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
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
          "\$$price",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        AppPrimaryButton(
          onTap: () {
            // productId
          },
          text: "Add to cart",
          height: 30,
        )
      ],
    );
  }
}
