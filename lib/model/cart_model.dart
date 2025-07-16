import 'dart:convert';

class CartModel {
  final int id;
  final int quantity;

  CartModel({required this.id, required this.quantity});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quantity': quantity};
  }

  static List<CartModel> listFromJson(String jsonStr) {
    final List<dynamic> data = json.decode(jsonStr) as List<dynamic>;
    return data
        .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
