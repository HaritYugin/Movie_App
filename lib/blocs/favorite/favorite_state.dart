import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Movie> favoriteMovies;

  const FavoriteLoaded({required this.favoriteMovies});

  @override
  List<Object> get props => [favoriteMovies];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
