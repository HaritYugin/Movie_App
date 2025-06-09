import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadAllMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies({required this.query});

  @override
  List<Object> get props => [query];
}
