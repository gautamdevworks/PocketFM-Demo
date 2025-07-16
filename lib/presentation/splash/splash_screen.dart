import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/const/app_const.dart';
import 'package:pocket_fm_demo/const/color_const.dart';
import 'package:pocket_fm_demo/const/image_const.dart';
import 'package:pocket_fm_demo/model/user_model.dart';
import 'package:pocket_fm_demo/presentation/auth/personal_details_screen.dart';
import 'package:pocket_fm_demo/presentation/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward().whenComplete(checkUser);
  }

  checkUser() async {
    final dynamic raw = await hiveService.getValue(key: 'user');
    UserModel? user;
    if (raw is Map) {
      user = UserModel.fromJson(Map<String, dynamic>.from(raw));
    }
    _controller.dispose();

    if (!mounted) return;
    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const PersonalDetailsScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(ImageConst.splash),
            ),
          ),
          const CupertinoActivityIndicator(color: ColorConst.blue, radius: 15),
        ],
      ),
    );
  }
}
