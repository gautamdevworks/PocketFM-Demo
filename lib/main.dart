import 'package:flutter/material.dart';
import 'package:pocket_fm_demo/const/app_theme.dart';
import 'package:pocket_fm_demo/presentation/splash/splash_screen.dart';
import 'package:pocket_fm_demo/service/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_fm_demo/service/hive_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open core box before the app runs.
  await Hive.initFlutter();
  await HiveService().initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: themeProvider.themeMode,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}

