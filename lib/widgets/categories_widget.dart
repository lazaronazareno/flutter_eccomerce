import 'package:e_commerce_app/model/category_item_model.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:e_commerce_app/widgets/category_item_widget.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({super.key});
  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'All',
      icon: 'assets/svg/home.svg',
    ),
    CategoryItem(
      title: 'Computers',
      icon: 'assets/svg/IconParkLaptop.svg',
    ),
    CategoryItem(
      title: 'Phones',
      icon: 'assets/svg/IconParkPhone.svg',
    ),
    CategoryItem(
      title: 'Tablets',
      icon: 'assets/svg/IconParkTablet.svg',
    ),
    CategoryItem(
      title: 'Watches',
      icon: 'assets/svg/IconParkSwatch.svg',
    ),
    CategoryItem(
      title: 'Music',
      icon: 'assets/svg/IconParkHeadset.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height * 0.22,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == categories.length - 1 ? 0 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: CategoryItemWidget(
                        category: CategoryItem(
                          title: categories[index].title,
                          icon: categories[index].icon,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
