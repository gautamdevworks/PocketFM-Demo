import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/presentation/home/widget/info_tile.dart';
import 'package:pocket_fm_demo/presentation/home/widget/review_tile.dart';
import 'package:pocket_fm_demo/presentation/widget/primary_button.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(ProductRepository()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(product.name),
              surfaceTintColor: Colors.transparent,
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: PrimaryButton(
                  onPressed: () async {
                    final cart = await hiveService.getValue(key: 'cart');
                    List<CartModel> cartItems = cart != null
                        ? CartModel.listFromJson(cart.toString())
                        : [];

                    // Check if the product is already in the cart
                    CartModel existingProduct = cartItems.firstWhere(
                      (item) => item.id == product.id,
                      orElse: () => CartModel(id: product.id, quantity: 0),
                    );

                    // Product exists, increase quantity
                    if (existingProduct.quantity == 0) {
                      cartItems.add(CartModel(id: product.id, quantity: 1));
                    } else {
                      cartItems = cartItems.map((item) {
                        if (item.id == product.id) {
                          return CartModel(
                            id: item.id,
                            quantity: item.quantity + 1,
                          );
                        }
                        return item;
                      }).toList();
                    }

                    context.read<ProductBloc>().add(
                      ProductAddedToCart(cartItems),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Product added to cart',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  text: 'Add to Cart',
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Additional images
                  if (product.images.length > 1)
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.images[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: product.images.length,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\u20B9${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 20.0,
                        unratedColor: Colors.amber.withAlpha(50),
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '(${product.reviews.length.toString()})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const Divider(height: 32),
                  InfoTile(label: 'Category', value: product.category),
                  InfoTile(label: 'Brand', value: product.brand),
                  InfoTile(label: 'SKU', value: product.sku),
                  InfoTile(label: 'Stock', value: product.stock.toString()),
                  InfoTile(label: 'Weight', value: '${product.weight}g'),
                  if (product.dimensions != null)
                    InfoTile(
                      label: 'Dimensions',
                      value:
                          '${product.dimensions!.width} x ${product.dimensions!.height} x ${product.dimensions!.depth}',
                    ),
                  InfoTile(
                    label: 'Warranty',
                    value: product.warrantyInformation,
                  ),
                  InfoTile(
                    label: 'Shipping',
                    value: product.shippingInformation,
                  ),
                  InfoTile(
                    label: 'Availability',
                    value: product.availabilityStatus,
                  ),
                  InfoTile(label: 'Return Policy', value: product.returnPolicy),
                  InfoTile(
                    label: 'Minimum Order Qty',
                    value: product.minimumOrderQuantity.toString(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(product.description),
                  const SizedBox(height: 16),
                  if (product.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: product.tags
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                  const SizedBox(height: 24),

                  if (product.reviews.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...product.reviews
                            .take(5)
                            .map((r) => ReviewTile(review: r)),
                      ],
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
