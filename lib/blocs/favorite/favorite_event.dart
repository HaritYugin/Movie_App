import 'package:equatable/equatable.dart';
import 'package:movie_app/models/movie.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {
  final String userId;

  const LoadFavorites({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddMovieToFavorites extends FavoriteEvent {
  final Movie movie;
  final String userId;

  const AddMovieToFavorites({required this.movie, required this.userId}); // Constructor now requires userId

  @override
  List<Object> get props => [movie, userId];
}

class RemoveMovieFromFavorites extends FavoriteEvent {
  final Movie movie;
  final String userId;

  const RemoveMovieFromFavorites({required this.movie, required this.userId}); // Constructor now requires userId

  @override
  List<Object> get props => [movie, userId];
}
