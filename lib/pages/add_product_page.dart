import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  final ProductModel? productModel;
  final bool isEditMode;

  const AddProductPage({super.key, this.productModel, this.isEditMode = false});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productImageUrlController =
      TextEditingController();
  String AppBarTitle = "Add Product";

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      setState(() {
        AppBarTitle = "Edit Product";
        _productNameController.text = widget.productModel!.title;
        _productPriceController.text = widget.productModel!.price.toString();
        _productImageUrlController.text = widget.productModel!.imageUrl;
      });
    }
  }

  void _addProduct(BuildContext context) {
    context.read<EcommerceBloc>().add(CreateProductEvent(
        id: widget.isEditMode ? widget.productModel!.id : null,
        title: _productNameController.text,
        imageUrl: _productImageUrlController.text,
        price: int.parse(
          _productPriceController.text,
        )));

    //Navigator.pop(context);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EcommerceBloc, EcommerceState>(
      listener: (context, state) {
        if (state.catalogStatus == CatalogScreenStatus.productAdded) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppBarTitle),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: [
                  buildTextInput("Product Name", _productNameController,
                      TextInputType.text),
                  const SizedBox(
                    height: 8,
                  ),
                  buildTextInput("Product Price", _productPriceController,
                      TextInputType.text),
                  const SizedBox(
                    height: 8,
                  ),
                  buildTextInput("Product Image URL",
                      _productImageUrlController, TextInputType.number),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => _addProduct(context),
                    child: Text(AppBarTitle),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildTextInput(String labelText, TextEditingController controller,
      TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
