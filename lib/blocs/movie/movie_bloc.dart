import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../models/movie.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<LoadAllMovies>(_onLoadAllMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadAllMovies(
      LoadAllMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.loadMoviesFromAsset();
      if (movies.isEmpty) {
        emit(MovieNoResults());
      } else {
        emit(MovieLoaded(movies: movies));
      }
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }

  Future<void> _onSearchMovies(
      SearchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      await movieRepository.loadMoviesFromAsset();
      final filteredMovies = movieRepository.searchMovies(event.query);
      if (filteredMovies.isEmpty) {
        emit(MovieNoResults());
      } else {
        emit(MovieLoaded(movies: filteredMovies));
      }
    } catch (e) {
      emit(MovieError(message: e.toString()));
    }
  }
}
