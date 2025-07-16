import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/presentation/category/product_category_filter_screen.dart';
import 'package:pocket_fm_demo/presentation/category/widget/category_card.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductBloc(ProductRepository())
            ..add(const ProductCategoriesRequested()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ProductCategoryFilterScreen(
                                category: category,
                              ),
                            ),
                          );
                        },
                        child: CategoryCard(category: category),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
