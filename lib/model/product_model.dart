import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String title;
  final double price;
  final String id;
  final String imageUrl;
  final String description;
  final String type;
  final int quantity;

  const ProductModel({
    required this.title,
    required this.price,
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.type,
    this.quantity = 0,
  });

  ProductModel copyWith({
    String? title,
    double? price,
    String? id,
    String? imageUrl,
    String? description,
    String? type,
    int? quantity,
  }) {
    return ProductModel(
      title: title ?? this.title,
      price: price ?? this.price,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props =>
      [title, price, id, imageUrl, description, type, quantity];
}
