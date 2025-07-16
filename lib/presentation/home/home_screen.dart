import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/presentation/category/category_screen.dart';
import 'package:pocket_fm_demo/presentation/home/home_body.dart';
import 'package:pocket_fm_demo/presentation/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 10,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (currentIndex == 0) HomeBody(),
            if (currentIndex == 1) CategoryScreen(),
            if (currentIndex == 2) ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
