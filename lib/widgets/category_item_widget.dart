import 'package:e_commerce_app/model/category_item_model.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryItem category;
  const CategoryItemWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.greyBackground,
          radius: 26,
          child: Image(
            width: 26,
            height: 26,
            image: Svg(category.icon),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          overflow: TextOverflow.ellipsis,
          category.title,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
