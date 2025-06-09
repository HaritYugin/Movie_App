import 'package:equatable/equatable.dart';
import 'package:movie_app/models/movie.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  final String userId;

  const LoadWatchlist({required this.userId});

  @override
  List<Object> get props => [userId];
}


class AddMovieToWatchlist extends WatchlistEvent {
  final Movie movie;
  final String userId;

  const AddMovieToWatchlist({required this.movie, required this.userId}); // Constructor now requires userId

  @override
  List<Object> get props => [movie, userId];
}


class RemoveMovieFromWatchlist extends WatchlistEvent {
  final Movie movie;
  final String userId;

  const RemoveMovieFromWatchlist({required this.movie, required this.userId}); // Constructor now requires userId

  @override
  List<Object> get props => [movie, userId];
}
