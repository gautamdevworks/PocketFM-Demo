import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_fm_demo/bloc/product_bloc.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/const/color_const.dart';
import 'package:pocket_fm_demo/model/user_model.dart';
import 'package:pocket_fm_demo/presentation/auth/personal_details_screen.dart';
import 'package:pocket_fm_demo/presentation/cart/cart_screen.dart';
import 'package:pocket_fm_demo/presentation/profile/order_screen.dart';
import 'package:pocket_fm_demo/repository/product_repository.dart';
import 'package:pocket_fm_demo/service/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return BlocProvider(
      create: (context) =>
          ProductBloc(ProductRepository())..add(const ProductRequested()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            children: [
              Text('Profile', style: Theme.of(context).textTheme.titleLarge),
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
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorConst.blue,
                                  ColorConst.blue.withValues(alpha: 0.5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),

                            child: Center(
                              child: Text(
                                user?.firstName?[0] ?? '',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            user?.email ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) => themeProvider.toggleTheme(value),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text(
                  'Cart',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (state.products.isEmpty) {
                    return;
                  }
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          CartScreen(products: state.products),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(
                  'Order',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (state.products.isEmpty) {
                    return;
                  }
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          OrderScreen(products: state.products),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text('Logout'),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: Theme.of(context).textTheme.titleMedium,
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
                            hiveService.clearBox();
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const PersonalDetailsScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
