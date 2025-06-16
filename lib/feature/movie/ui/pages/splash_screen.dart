import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/di/di.dart';
import 'package:movieapp/feature/movie/ui/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _initializeApp();
  }

  void _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  Future<void> _initializeApp() async {
    await AppDI.init();
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: AppDI.provideMovieRepository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AppDI.provideMovieBloc()),
              BlocProvider(create: (context) => AppDI.provideFavoriteBloc()),
              BlocProvider(create: (context) => AppDI.provideMovieSearchBloc()),
            ],
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/splash_logo.png',
                  fit : BoxFit.cover,
                ),
              )
            ),
          );
        },
      ),
    );
  }
}
