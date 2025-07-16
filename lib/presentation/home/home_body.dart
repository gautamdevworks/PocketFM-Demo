import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/const/color_const.dart';
import 'package:pocket_fm_demo/const/image_const.dart';
import 'package:pocket_fm_demo/model/product_model.dart';
import 'package:pocket_fm_demo/model/user_model.dart';
import 'package:pocket_fm_demo/presentation/cart/cart_screen.dart';
import 'package:pocket_fm_demo/presentation/home/product_details_screen.dart';
import 'package:pocket_fm_demo/presentation/home/widget/product_card.dart';
import 'package:pocket_fm_demo/presentation/widget/primary_textfield.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductBloc(ProductRepository())..add(const ProductRequested()),
      child: Expanded(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            return Column(
              children: [
                FutureBuilder(
                  future: hiveService.getValue(key: 'user'),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      UserModel? user;
                      if (asyncSnapshot.data is Map) {
                        user = UserModel.fromJson(
                          Map<String, dynamic>.from(asyncSnapshot.data),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: Text(
                                user?.firstName?[0] ?? '',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),

                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        CartScreen(products: state.products),
                                  ),
                                );
                                context.read<ProductBloc>().add(
                                  const ProductRequested(),
                                );
                              },
                              child: badges.Badge(
                                badgeAnimation: badges.BadgeAnimation.rotation(
                                  animationDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  colorChangeAnimationDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  curve: Curves.easeInOut,
                                  colorChangeAnimationCurve: Curves.easeInOut,
                                ),
                                position: badges.BadgePosition.topEnd(
                                  top: -10,
                                  end: -10,
                                ),
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: ColorConst.blue,
                                  padding: const EdgeInsets.all(7),
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 0,
                                ),
                                badgeContent: Text(
                                  state.cart?.length.toString() ?? '0',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                ),
                                child: Icon(Icons.shopping_cart, size: 30),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),
                SearchTextfield(
                  onChanged: (value) {
                    context.read<ProductBloc>().add(ProductSearched(value));
                  },
                ),
                const SizedBox(height: 16),
                if (state.searchedProducts.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          ImageConst.emptyProduct,
                          height: 250,
                          width: 250,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                builder: (_) =>
                                    ProductDetailsScreen(product: p),
                              ),
                            );
                            context.read<ProductBloc>().add(
                              const ProductRequested(),
                            );
                          },
                          child: ProductCard(product: p),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
