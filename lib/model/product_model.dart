import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String title;
  final int price;
  final String id;
  final String imageUrl;
  final String description;
  final String type;
  final int quantity;
  final bool isFavorite;

  const ProductModel({
    required this.title,
    required this.price,
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.type,
    this.quantity = 1,
    this.isFavorite = false,
  });

  ProductModel copyWith({
    String? title,
    int? price,
    String? id,
    String? imageUrl,
    String? description,
    String? type,
    int? quantity,
    bool? isFavorite,
  }) {
    return ProductModel(
      title: title ?? this.title,
      price: price ?? this.price,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props =>
      [title, price, id, imageUrl, description, type, quantity, isFavorite];
}
