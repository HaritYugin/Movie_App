import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/favorite/favorite_bloc.dart'; // Import FavoriteBloc
import 'package:movie_app/blocs/favorite/favorite_event.dart'; // Import FavoriteEvent
import 'package:movie_app/blocs/favorite/favorite_state.dart'; // Import FavoriteState
import 'package:movie_app/blocs/auth/auth_bloc.dart'; // IMPORTANT: Import AuthBloc to get current user
import 'package:movie_app/blocs/auth/auth_state.dart'; // IMPORTANT: Import AuthState
import 'package:movie_app/screens/auth_screen.dart'; // If redirection is needed
import 'package:movie_app/widgets/loading_indicator.dart'; // Import LoadingIndicator
import 'package:movie_app/widgets/error_message.dart'; // Import ErrorMessage
import 'package:movie_app/widgets/movie_list_item.dart'; // Import MovieListItem

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<FavoriteBloc>().add(LoadFavorites(userId: authState.user.username));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const LoadingIndicator();
          } else if (state is FavoriteLoaded) {
            if (state.favoriteMovies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favorite movies yet. Mark some!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = state.favoriteMovies[index];
                return MovieListItem(movie: movie);
              },
            );
          } else if (state is FavoriteError) {
            // Get userId to pass to retry event
            final authState = context.read<AuthBloc>().state;
            String? userIdForRetry;
            if (authState is AuthAuthenticated) {
              userIdForRetry = authState.user.username;
            }
            return ErrorMessage(
              message: 'Failed to load favorites: ${state.message}',
              // IMPORTANT: Pass the userId to the retry event
              onRetry: userIdForRetry != null ? () => context.read<FavoriteBloc>().add(LoadFavorites(userId: userIdForRetry!)) : null,
            );
          }
          return const Center(child: Text('Loading favorites...'));
        },
      ),
    ),
    );
  }
}
