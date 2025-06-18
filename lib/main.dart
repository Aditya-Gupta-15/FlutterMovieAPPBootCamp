import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/theme/app_theme.dart';
import 'package:movieapp/core/di/di.dart';
import 'package:movieapp/feature/movie/ui/pages/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final ValueNotifier<AppTheme> themeNotifier = ValueNotifier(AppTheme.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDI.init();

  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
  runApp(
    RepositoryProvider.value(
      value: AppDI.provideMovieRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppDI.provideMovieBloc()),
          BlocProvider(create: (context) => AppDI.provideFavoriteBloc()),
          BlocProvider(create: (context) => AppDI.provideMovieSearchBloc()),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
          home: const HomeScreen(),
        );
      },
    );
  }
}
