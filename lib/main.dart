
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importing custom models
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/user.dart';

// Repositories
import 'package:movie_app/repositories/movie_repository.dart';
import 'package:movie_app/repositories/auth_repository.dart';
import 'package:movie_app/repositories/watchlist_repository.dart';
import 'package:movie_app/repositories/favorites_repository.dart';

// Blocs
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_event.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'package:movie_app/blocs/movie/movie_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_bloc.dart';
import 'package:movie_app/blocs/favorite/favorite_bloc.dart';

// Screens
import 'package:movie_app/screens/auth_screen.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<MovieRepository>(
          create: (context) => MovieRepository(),
        ),
        RepositoryProvider<WatchlistRepository>(
          create: (context) => WatchlistRepository(),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<MovieBloc>(
            create: (context) =>
                MovieBloc(movieRepository: context.read<MovieRepository>()),
          ),
          BlocProvider<WatchlistBloc>(
            create: (context) => WatchlistBloc(
              watchlistRepository: context.read<WatchlistRepository>(),
              movieRepository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider<FavoriteBloc>(
            create: (context) => FavoriteBloc(
              favoritesRepository: context.read<FavoritesRepository>(),
              movieRepository: context.read<MovieRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Movie App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              labelStyle: TextStyle(color: Colors.grey[600]),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
          home: const SplashScreen(),

        ),
      ),
    );
  }
}