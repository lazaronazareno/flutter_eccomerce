import 'package:e_commerce_app/pages/add_product_page.dart';
import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:e_commerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EcommerceBloc>()..add(FetchCatalogProductsEvent()),
      child: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalog Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EcommerceBloc, EcommerceState>(
        builder: (context, state) {
          if (state.catalogStatus == CatalogScreenStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.catalogProducts.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.builder(
            itemCount: state.catalogProducts.length,
            itemBuilder: (context, index) {
              final catalogProduct = state.catalogProducts[index];
              return ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductPage(
                            productModel: catalogProduct, isEditMode: true))),
                title: Text(catalogProduct.title),
                subtitle: Text("\$${catalogProduct.price.toString()}"),
                trailing: Image.network(catalogProduct.imageUrl,
                    width: 100, height: 100),
                leading: IconButton(
                    onPressed: () {
                      context.read<EcommerceBloc>().add(
                          DeleteProductEvent(productId: catalogProduct.id));
                    },
                    icon: Icon(Icons.delete, color: AppColors.red)),
              );
            },
          );
        },
      ),
    );
  }
}
