import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/watchlist/watchlist_event.dart';
import 'package:movie_app/blocs/watchlist/watchlist_state.dart';
import 'package:movie_app/repositories/watchlist_repository.dart';
import 'package:movie_app/repositories/movie_repository.dart';
import 'package:movie_app/models/movie.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository watchlistRepository;
  final MovieRepository movieRepository;

  WatchlistBloc({
    required this.watchlistRepository,
    required this.movieRepository,
  }) : super(WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
  }

  Future<void> _onLoadWatchlist(
      LoadWatchlist event, Emitter<WatchlistState> emit) async {
    emit(WatchlistLoading());
    try {
      final allMovies = await movieRepository.loadMoviesFromAsset();
      final watchlistIds = await watchlistRepository.getWatchlistMovieIds(event.userId);
      final watchlistMovies = allMovies
          .where((movie) => watchlistIds.contains(movie.id))
          .toList();
      emit(WatchlistLoaded(watchlistMovies: watchlistMovies));
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }

  Future<void> _onAddMovieToWatchlist(
      AddMovieToWatchlist event, Emitter<WatchlistState> emit) async {
    try {
      await watchlistRepository.addMovieToWatchlist(event.movie.id, event.userId);
      add(LoadWatchlist(userId: event.userId));
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }

  Future<void> _onRemoveMovieFromWatchlist(
      RemoveMovieFromWatchlist event, Emitter<WatchlistState> emit) async {
    try {
      await watchlistRepository.removeMovieFromWatchlist(event.movie.id, event.userId);
      add(LoadWatchlist(userId: event.userId));
    } catch (e) {
      emit(WatchlistError(message: e.toString()));
    }
  }
}
