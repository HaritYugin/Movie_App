import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String posterUrl;
  final String description;
  final double rating;
  final String duration;
  final String genre;
  final String releaseDate;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.rating,
    required this.duration,
    required this.genre,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'] as String,
      genre: json['genre'] as String,
      releaseDate: json['releaseDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'description': description,
      'rating': rating,
      'duration': duration,
      'genre': genre,
      'releaseDate': releaseDate,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    posterUrl,
    description,
    rating,
    duration,
    genre,
    releaseDate,
  ];
}
