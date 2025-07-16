import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/color_const.dart';
import 'package:pocket_fm_demo/const/image_const.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class OrderScreen extends StatelessWidget {
  final List<ProductModel> products;
  const OrderScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBloc(ProductRepository())..add(const FetchOrder()),
      lazy: false,
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
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
                          'No items in order',
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
                        return Card(
                          color: Theme.of(context).cardColor,
                          child: Column(
                            children: [
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Quantity: ${cart?.quantity.toString() ?? ''}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          'Price: ${(product.price)}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
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
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
