import 'dart:ui';

class Product {
  int? id;
  String name;
  int quantity;
  double price;
  String? imagePath;
  Color? color;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'] is int ? (map['price'] as int).toDouble() : map['price'],
      imagePath: map['imagePath'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, quantity: $quantity, price: $price, imagePath: $imagePath, color: $color}';
  }
}