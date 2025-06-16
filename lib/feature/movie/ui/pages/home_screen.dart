import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/theme/app_theme.dart';
import 'package:movieapp/core/di/di.dart';
import 'package:movieapp/feature/movie/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:movieapp/feature/movie/bloc/movie_bloc.dart';
import 'package:movieapp/feature/movie/repository/entities/movie_entity.dart';
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
                useRootNavigator: true,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return BlocProvider.value(
                    value: AppDI.provideMovieSearchBloc(),
                    child: const SearchBottomSheet(),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BlocProvider.value(
                  value: context.read<FavoriteBloc>(),
                  child: const FavoriteMoviesPage(),
                )),
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
          List<MovieEntity> movies = [];
          int currentPage = 1;
          bool hasReachedMaxPage = false;
          bool isPaginating = false;
          String? paginationError;
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            movies = state.movies;
            currentPage = state.currentPage;
            hasReachedMaxPage = state.hasReachedMaxPage;
          } else if (state is MoviePaginationLoading) {
            movies = state.movies;
            currentPage = state.currentPage;
            hasReachedMaxPage = state.hasReachedMaxPage;
            isPaginating = true;
          } else if (state is MoviePaginationError) {
            movies = state.movies;
            currentPage = state.currentPage;
            hasReachedMaxPage = state.hasReachedMaxPage;
            paginationError = state.error;
          } else if (state is MovieError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return Column(
            children: [
              Expanded(
                child: movieCardCreation(
                  context: context,
                  movies: movies,
                  currentPage: currentPage,
                  hasReachedMaxPage: hasReachedMaxPage,
                  isPaginating: isPaginating,
                ),
              ),
              if (isPaginating)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (paginationError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    paginationError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
