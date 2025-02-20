import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/pages/cart_page.dart';
import 'package:e_commerce_app/pages/catalog_page.dart';
import 'package:e_commerce_app/pages/home_page.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const CatalogPage(),
    const CartPage(),
    const Center(
      child: Text("Favorites Page under construction"),
    ),
    const Center(
      child: Text("Profile Page under construction"),
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: _pages[selectedIndex],
        bottomNavigationBar: Container(
            width: size.width,
            height: size.height * 0.10,
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                itemButtonMenu(
                  onTap: () => onItemTapped(0),
                  icon: Icons.home,
                  title: 'Home',
                  isactive: selectedIndex == 0,
                ),
                itemButtonMenu(
                  onTap: () => onItemTapped(1),
                  icon: Icons.manage_search_outlined,
                  title: 'Catalog',
                  isactive: selectedIndex == 1,
                ),
                itemButtonMenu(
                  onTap: () => onItemTapped(2),
                  icon: Icons.shopping_cart_outlined,
                  title: 'Cart',
                  isactive: selectedIndex == 2,
                  isCartItem: true,
                ),
                itemButtonMenu(
                  onTap: () => onItemTapped(3),
                  icon: Icons.favorite_border,
                  title: 'Favorite',
                  isactive: selectedIndex == 3,
                ),
                itemButtonMenu(
                  onTap: () => onItemTapped(4),
                  icon: Icons.person,
                  title: 'Profile',
                  isactive: selectedIndex == 4,
                ),
              ],
            )));
  }

  Widget itemButtonMenu(
      {required Function() onTap,
      required IconData icon,
      required String title,
      required bool isactive,
      bool isCartItem = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isactive ? AppColors.green : AppColors.black,
              ),
              Text(
                title,
                style: TextStyle(color: AppColors.black, fontSize: 12),
              ),
            ],
          ),
        ),
        if (isCartItem)
          BlocBuilder<EcommerceBloc, EcommerceState>(
            builder: (context, state) {
              if (state.cartProducts.isEmpty) {
                return const SizedBox.shrink();
              }

              final totalItems = state.cartProducts.fold<int>(
                0,
                (prev, item) => prev + item.quantity,
              );
              return Positioned(
                right: -10,
                top: -5,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    border: Border.all(color: AppColors.white, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      /* state.cartProducts.length.toString(), */
                      totalItems.toString(),
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          )
      ],
    );
  }
}


/* otra forma de hacer que el iconButton no tenga espacio con un texto debajo
 IconButton(
              icon: Icon(
                icon,
                color: isactive ? AppColors.green : AppColors.black,
              ),
              onPressed: onTap,
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // the '2023' part
              ),
            ),
            Text(
              title,
              style: TextStyle(color: AppColors.black, fontSize: 12),
            ), */