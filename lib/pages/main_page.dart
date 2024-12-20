import 'package:e_commerce_app/pages/cart_page.dart';
import 'package:e_commerce_app/pages/home_page.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const Center(
      child: Text("Catalog Page under construction"),
    ),
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
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        //no hace falta pasarle algo por que es del mismo tipo que onTap
        onTap: onItemTapped,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(color: AppColors.black),
        unselectedItemColor: AppColors.black,
        selectedItemColor: AppColors.green,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home,
              ),
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.manage_search_outlined,
              ),
              icon: Icon(
                Icons.manage_search_outlined,
              ),
              label: 'Catalog'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.shopping_cart_outlined,
              ),
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: 'Cart'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite_border,
              ),
              icon: Icon(
                Icons.favorite_border,
              ),
              label: 'Favorite'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
              ),
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
