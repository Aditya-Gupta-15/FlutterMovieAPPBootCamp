import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/theme/app_theme.dart';
import 'package:movieapp/feature/movie/bloc/movie_bloc.dart';
import 'package:movieapp/feature/movie/repository/movie_repository.dart';
import 'package:movieapp/feature/movie/bloc/search_bloc/movie_search_bloc.dart';
import 'package:movieapp/feature/movie/ui/pages/cart.dart';
import 'package:movieapp/feature/movie/ui/pages/favorite_movies_page.dart';
import 'package:movieapp/feature/movie/ui/widgets/bottom_sheet_widget.dart';
import 'package:movieapp/feature/movie/ui/widgets/movie_card.dart';
import 'package:movieapp/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return BlocProvider(
                    create: (_) => MovieSearchBloc(context.read<MovieRepository>()),
                    child: const SearchBottomSheet(),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder:(_) => const FavoriteMoviesPage() ),
                );
            },
          ),
          Switch(
            value: themeNotifier.value == AppTheme.dark,
            onChanged: (value) {
              themeNotifier.value = value ? AppTheme.dark : AppTheme.light;
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('No movies found'));
            }
            return movieCardCreation(state.movies);
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
