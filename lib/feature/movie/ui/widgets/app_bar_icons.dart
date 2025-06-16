import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/theme/app_theme.dart';
import 'package:movieapp/core/di/di.dart';
import 'package:movieapp/feature/movie/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:movieapp/feature/movie/ui/pages/cart.dart';
import 'package:movieapp/feature/movie/ui/pages/favorite_movies_page.dart';
import 'package:movieapp/feature/movie/ui/widgets/bottom_sheet_widget.dart';
import 'package:movieapp/main.dart';

Widget buildCartButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.shopping_cart),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    },
  );
}

Widget buildSearchButton(BuildContext context) {
  return IconButton(
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
  );
}

Widget buildFavoriteButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.favorite),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<FavoriteBloc>(),
            child: const FavoriteMoviesPage(),
          ),
        ),
      );
    },
  );
}

Widget buildThemeSwitch(BuildContext context) {
  return Switch(
    value: themeNotifier.value == AppTheme.dark,
    onChanged: (value) {
      themeNotifier.value = value ? AppTheme.dark : AppTheme.light;
    },
  );
}
