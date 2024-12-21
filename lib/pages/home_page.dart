import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:e_commerce_app/widgets/categories_widget.dart';
import 'package:e_commerce_app/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EcommerceBloc>()..add(FetchProductsEvent()),
      child: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: AppColors.green,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: Svg('assets/svg/offer.svg', color: AppColors.green),
              ),
            ),
          ),
        ),
        title: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Text("Delivery Address",
                  style: TextStyle(fontSize: 12, color: AppColors.greenLight)),
              Text(
                "92 High Street, London",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black),
              ),
            ],
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: AppColors.greyBackground,
            child: IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: const Column(
          children: [CategoriesWidget(), Expanded(child: ProductWidget())],
        ),
      ),
    );
  }
}


/* Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Search the entire shop",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: AppColors.greyBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ), */