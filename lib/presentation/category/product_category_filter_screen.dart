import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/presentation/home/product_details_screen.dart';
import 'package:pocket_fm_demo/presentation/home/widget/product_card.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class ProductCategoryFilterScreen extends StatelessWidget {
  final String category;
  const ProductCategoryFilterScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductBloc(ProductRepository())
            ..add(ProductCategorySelected(category)),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                formatCategoryName(category),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            body: SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.searchedProducts.length,
                itemBuilder: (context, index) {
                  final ProductModel p = state.searchedProducts[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => ProductDetailsScreen(product: p),
                        ),
                      );
                    },
                    child: ProductCard(product: p),
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
