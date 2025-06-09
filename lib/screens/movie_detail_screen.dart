import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/blocs/watchlist/watchlist_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_event.dart';
import 'package:movie_app/blocs/watchlist/watchlist_state.dart';
import 'package:movie_app/blocs/favorite/favorite_bloc.dart';
import 'package:movie_app/blocs/favorite/favorite_event.dart';
import 'package:movie_app/blocs/favorite/favorite_state.dart';
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'dart:ui';
class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  String? _getCurrentUserId(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.username;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = _getCurrentUserId(context);

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(context, 'Authentication required for this action.', isError: true);
      });
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Please log in to view details and manage lists.')),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(movie.title),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image (Blurred)
                      Positioned.fill(
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          color: const Color.fromRGBO(255, 255, 255, 0.4),
                          colorBlendMode: BlendMode.modulate,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),

                      // Blur Filter
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),

                      // Foreground Poster Image
                      Hero(
                        tag: 'movie-poster-${movie.id}',
                        child: Image.network(
                          movie.posterUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: double.infinity,
                            height: 300,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movie Details Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.star_rate_rounded, color: Colors.amber[700], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${movie.rating} / 10',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Icon(Icons.access_time, color: Colors.grey[600], size: 22),
                        const SizedBox(width: 8),
                        Text(
                          movie.duration,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Genre: ${movie.genre}',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Release Date: ${movie.releaseDate}',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: BlocBuilder<WatchlistBloc, WatchlistState>(
                            builder: (context, state) {
                              bool isInWatchlist = false;
                              if (state is WatchlistLoaded) {
                                isInWatchlist =
                                    state.watchlistMovies.any((m) => m.id == movie.id);
                              }
                              return ElevatedButton.icon(
                                onPressed: () {
                                  if (isInWatchlist) {
                                    context.read<WatchlistBloc>().add(
                                        RemoveMovieFromWatchlist(movie: movie, userId: userId));
                                    _showSnackBar(context, 'Removed from Watchlist');
                                  } else {
                                    context.read<WatchlistBloc>().add(
                                        AddMovieToWatchlist(movie: movie, userId: userId));
                                    _showSnackBar(context, 'Added to Watchlist');
                                  }
                                },
                                icon: Icon(
                                  isInWatchlist ? Icons.check_circle : Icons.add_task,
                                  color: isInWatchlist ? Colors.white : Colors.blue,
                                ),
                                label: Text(
                                  isInWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                                  style: TextStyle(
                                    color: isInWatchlist ? Colors.white : Colors.blue,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  isInWatchlist ? Colors.blue : Colors.blue.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 3,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BlocBuilder<FavoriteBloc, FavoriteState>(
                            builder: (context, state) {
                              bool isFavorite = false;
                              if (state is FavoriteLoaded) {
                                isFavorite = state.favoriteMovies.any((m) => m.id == movie.id);
                              }
                              return ElevatedButton.icon(
                                onPressed: () {
                                  if (isFavorite) {
                                    context.read<FavoriteBloc>().add(
                                        RemoveMovieFromFavorites(movie: movie, userId: userId));
                                    _showSnackBar(context, 'Removed from Favorites');
                                  } else {
                                    context.read<FavoriteBloc>().add(
                                        AddMovieToFavorites(movie: movie, userId: userId));
                                    _showSnackBar(context, 'Added to Favorites');
                                  }
                                },
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.white : Colors.redAccent,
                                ),
                                label: Text(
                                  isFavorite ? 'Favorited' : 'Add to Favorites',
                                  style: TextStyle(
                                    color: isFavorite ? Colors.white : Colors.redAccent,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  isFavorite ? Colors.redAccent : Colors.red.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.redAccent),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 3,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
