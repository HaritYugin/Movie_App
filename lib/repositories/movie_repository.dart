import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/movie.dart';

class MovieRepository {
  List<Movie> _allMovies = [];

  Future<List<Movie>> loadMoviesFromAsset() async {
    try {
      final String response = await rootBundle.loadString('assets/movies.json');
      final data = await json.decode(response);
      _allMovies = (data['movies'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
      return _allMovies;
    } catch (e) {
      print('Error loading movies from asset: $e');
      throw Exception('Failed to load movies from asset');
    }
  }

  List<Movie> searchMovies(String query) {
    if (query.isEmpty) {
      return _allMovies;
    }
    return _allMovies
        .where((movie) =>
        movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
