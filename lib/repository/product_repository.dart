import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> fetchProducts() async {
    final jsonStr = await rootBundle.loadString('assets/json/products.json');
    return ProductModel.listFromJson(jsonStr);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await fetchProducts();
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.tags.any(
                (tag) => tag.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final jsonStr = await rootBundle.loadString('assets/json/products.json');
    final products = ProductModel.listFromJson(jsonStr);
    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList();
    return categories;
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final jsonStr = await rootBundle.loadString('assets/json/products.json');
    final products = ProductModel.listFromJson(jsonStr);
    return products.where((product) => product.category == category).toList();
  }

  Future<void> addToCart(List<CartModel> cart) async {
    final jsonCart = jsonEncode(cart.map((e) => e.toJson()).toList());
    await hiveService.addValue(key: 'cart', value: jsonCart);
    final carts = await hiveService.getValue(key: 'cart');
    if (carts != null) {
      CartModel.listFromJson(carts);
    }
    return;
  }

  Future<List<CartModel>> fetchCart() async {
    final value = await hiveService.getValue(key: 'cart');
    List<CartModel> cartItems = [];
    if (value != null) {
      if (value is String) {
        cartItems = CartModel.listFromJson(value);
      } else if (value is List) {
        cartItems = value
            .map((e) => CartModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return cartItems;
  }

  Future<void> orderProducts(List<CartModel> cart) async {
    final jsonCart = jsonEncode(cart.map((e) => e.toJson()).toList());
    await hiveService.addValue(key: 'order', value: jsonCart);
    final carts = await hiveService.getValue(key: 'order');
    if (carts != null) {
      CartModel.listFromJson(carts);
    }
    return;
  }

  Future<List<CartModel>> fetchOrder() async {
    final value = await hiveService.getValue(key: 'order');
    List<CartModel> orderItems = [];
    if (value != null) {
      if (value is String) {
        orderItems = CartModel.listFromJson(value);
      } else if (value is List) {
        orderItems = value
            .map((e) => CartModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return orderItems;
  }
}
