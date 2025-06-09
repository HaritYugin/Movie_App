import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_event.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'package:movie_app/blocs/movie/movie_bloc.dart';
import 'package:movie_app/blocs/movie/movie_event.dart';
import 'package:movie_app/blocs/movie/movie_state.dart';
import 'package:movie_app/blocs/watchlist/watchlist_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_event.dart';
import 'package:movie_app/blocs/favorite/favorite_bloc.dart';
import 'package:movie_app/blocs/favorite/favorite_event.dart';
import 'package:movie_app/screens/auth_screen.dart';
import 'package:movie_app/screens/watchlist_screen.dart';
import 'package:movie_app/screens/favorites_screen.dart';
import 'package:movie_app/widgets/loading_indicator.dart';
import 'package:movie_app/widgets/error_message.dart';
import 'package:movie_app/widgets/movie_list_item.dart';
import 'package:movie_app/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();


    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.username;
    }


    context.read<MovieBloc>().add(LoadAllMovies());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.username;
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
      return;
    }


    if (index == 1) {
      context.read<WatchlistBloc>().add(LoadWatchlist(userId: _currentUserId!));
    } else if (index == 2) {
      context.read<FavoriteBloc>().add(LoadFavorites(userId: _currentUserId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Houseful My Show'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),

      body: _selectedIndex == 0
          ? _buildMovieSearchBody()
          : (_selectedIndex == 1 ? const WatchlistScreen() : const FavoritesScreen()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    ),
    );
  }

  Widget _buildMovieSearchBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
            onChanged: (query) {
              context.read<MovieBloc>().add(SearchMovies(query: query));
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return const LoadingIndicator();
                } else if (state is MovieLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieListItem(movie: movie);
                    },
                  );
                } else if (state is MovieNoResults) {
                  return const ErrorMessage(
                    message: 'No movies found matching your search.',
                  );
                } else if (state is MovieError) {
                  return ErrorMessage(
                    message: 'Failed to load movies: ${state.message}',
                    onRetry: () => context.read<MovieBloc>().add(LoadAllMovies()),
                  );
                }
                return const Center(
                  child: Text('Start searching for movies!'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
