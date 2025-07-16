import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';

class OrderCard extends StatelessWidget {
  final ProductModel product;
  final CartModel cart;
  const OrderCard({super.key, required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(product.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Quantity: ${cart.quantity.toString()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'TotalPrice: ${(product.price) * cart.quantity}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
