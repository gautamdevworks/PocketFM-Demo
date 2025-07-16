import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';

class CartCard extends StatelessWidget {
  final ProductModel product;
  final CartModel cart;
  final Function(CartModel) onDelete;
  final Function(CartModel) onAdd;
  final Function(CartModel) onRemove;
  const CartCard({
    super.key,
    required this.product,
    required this.cart,
    required this.onDelete,
    required this.onAdd,
    required this.onRemove,
  });

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
                      'Price: ${(product.price)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text('Delete'),
                      content: Text(
                        'Are you sure you want to delete this item?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(cart);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    child: IconButton(
                      onPressed: () {
                        onRemove(cart);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ),

                  Text(
                    cart.quantity.toString(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  CircleAvatar(
                    child: IconButton(
                      onPressed: () {
                        onAdd(cart);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
