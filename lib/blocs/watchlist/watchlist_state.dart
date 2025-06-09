import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> watchlistMovies;

  const WatchlistLoaded({required this.watchlistMovies});

  @override
  List<Object> get props => [watchlistMovies];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError({required this.message});

  @override
  List<Object> get props => [message];
}
