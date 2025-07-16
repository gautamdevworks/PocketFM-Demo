import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/color_const.dart';
import 'package:pocket_fm_demo/const/image_const.dart';
import 'package:pocket_fm_demo/model/cart_model.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/presentation/cart/widget/cart_card.dart';
import 'package:pocket_fm_demo/presentation/widget/primary_button.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class CartScreen extends StatelessWidget {
  final List<ProductModel> products;
  const CartScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBloc(ProductRepository())..add(const ProductRequested()),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: state.cart?.isEmpty ?? true
                ? null
                : SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Total Price: ${(state.cart?.map((e) => e.quantity * products.firstWhere((p) => p.id == e.id).price).reduce((a, b) => a + b) ?? 0)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          PrimaryButton(
                            text: 'Place Order',
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                OrderProducts(state.cart ?? []),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Order placed successfully',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            appBar: AppBar(
              title: const Text('Cart'),
              centerTitle: true,
              surfaceTintColor: Colors.transparent,
            ),
            body: state.isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(color: ColorConst.blue),
                  )
                : state.cart?.isEmpty ?? true
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageConst.emptyCart,
                          height: 250,
                          width: 250,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No items in cart',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.cart?.length ?? 0,
                      itemBuilder: (context, index) {
                        final cart = state.cart?[index];

                        final product = products.firstWhere(
                          (product) => product.id == cart?.id,
                        );
                        return CartCard(
                          product: product,
                          cart: cart!,
                          onDelete: (cart) {
                            List<CartModel> cartList =
                                state.cart
                                    ?.where((e) => e.id != cart.id)
                                    .toList() ??
                                [];

                            context.read<ProductBloc>().add(
                              ProductAddedToCart(cartList),
                            );
                          },
                          onAdd: (cart) {
                            context.read<ProductBloc>().add(
                              ProductAddedToCart(
                                state.cart
                                        ?.map(
                                          (e) => e.id == cart.id
                                              ? CartModel(
                                                  id: e.id,
                                                  quantity: e.quantity + 1,
                                                )
                                              : e,
                                        )
                                        .toList() ??
                                    [],
                              ),
                            );
                          },
                          onRemove: (cart) {
                            List<CartModel> cartList =
                                state.cart
                                    ?.map(
                                      (e) => e.id == cart.id
                                          ? CartModel(
                                              id: e.id,
                                              quantity: e.quantity - 1,
                                            )
                                          : e,
                                    )
                                    .toList() ??
                                [];
                            cartList.removeWhere((e) => e.quantity == 0);

                            context.read<ProductBloc>().add(
                              ProductAddedToCart(cartList),
                            );
                          },
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
