import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/feature/movie/bloc/search_bloc/movie_search_bloc.dart';
import 'package:movieapp/feature/movie/ui/widgets/movie_card.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _Controller = TextEditingController();
  Timer? _debounce;
  final int _minSearchLength = 3;

  @override
  void dispose(){
    _debounce?.cancel();
    _Controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= _minSearchLength) {
        context.read<MovieSearchBloc>().add(SearchMoviesEvent(query));
      } else {
        context.read<MovieSearchBloc>().add(ClearSearchEvent());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _Controller,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: "Search movies...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  if (state is MovieSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieSearchLoaded) {
                    if (state.movies.isEmpty) {
                      return const Center(child: Text('No results found.'));
                    }
                    return movieCardCreation(state.movies);
                  } else if (state is MovieSearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('Start typing to search.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}