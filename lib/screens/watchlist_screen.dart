import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_event.dart';
import 'package:movie_app/blocs/watchlist/watchlist_state.dart';
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'package:movie_app/screens/auth_screen.dart';
import 'package:movie_app/widgets/loading_indicator.dart';
import 'package:movie_app/widgets/error_message.dart';
import 'package:movie_app/widgets/movie_list_item.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<WatchlistBloc>().add(LoadWatchlist(userId: authState.user.username));
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
        title: const Text('My Watchlist'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const LoadingIndicator();
          } else if (state is WatchlistLoaded) {
            if (state.watchlistMovies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_filter, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Your watchlist is empty. Add some movies!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.watchlistMovies.length,
              itemBuilder: (context, index) {
                final movie = state.watchlistMovies[index];
                return MovieListItem(movie: movie);
              },
            );
          } else if (state is WatchlistError) {
            final authState = context.read<AuthBloc>().state;
            String? userIdForRetry;
            if (authState is AuthAuthenticated) {
              userIdForRetry = authState.user.username;
            }
            return ErrorMessage(
              message: 'Failed to load watchlist: ${state.message}',
              onRetry: userIdForRetry != null ? () => context.read<WatchlistBloc>().add(LoadWatchlist(userId: userIdForRetry!)) : null,
            );
          }
          return const Center(child: Text('Loading watchlist...'));
        },
      ),
    ),
    );
  }
}
