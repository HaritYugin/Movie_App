import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/favorite/favorite_event.dart';
import 'package:movie_app/blocs/favorite/favorite_state.dart';
import 'package:movie_app/repositories/favorites_repository.dart';
import 'package:movie_app/repositories/movie_repository.dart';
import 'package:movie_app/models/movie.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoritesRepository favoritesRepository;
  final MovieRepository movieRepository;

  FavoriteBloc({
    required this.favoritesRepository,
    required this.movieRepository,
  }) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddMovieToFavorites>(_onAddMovieToFavorites);
    on<RemoveMovieFromFavorites>(_onRemoveMovieFromFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final allMovies = await movieRepository.loadMoviesFromAsset();
      final favoriteIds = await favoritesRepository.getFavoriteMovieIds(event.userId);
      final favoriteMovies = allMovies
          .where((movie) => favoriteIds.contains(movie.id))
          .toList();
      emit(FavoriteLoaded(favoriteMovies: favoriteMovies));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onAddMovieToFavorites(
      AddMovieToFavorites event, Emitter<FavoriteState> emit) async {
    try {
      await favoritesRepository.addMovieToFavorites(event.movie.id, event.userId);
      add(LoadFavorites(userId: event.userId));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onRemoveMovieFromFavorites(
      RemoveMovieFromFavorites event, Emitter<FavoriteState> emit) async {
    try {
      await favoritesRepository.removeMovieFromFavorites(event.movie.id, event.userId);
      add(LoadFavorites(userId: event.userId));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }
}
