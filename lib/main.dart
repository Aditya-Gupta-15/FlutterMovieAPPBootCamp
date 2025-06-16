import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/theme/app_theme.dart';
import 'package:movieapp/feature/movie/ui/pages/splash_screen.dart';

final ValueNotifier<AppTheme> themeNotifier = ValueNotifier(AppTheme.light);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'Movie App',
          theme: appThemeData[currentTheme],
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
