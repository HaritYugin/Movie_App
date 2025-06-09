import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart'; // Assuming your Movie model is here
import 'package:movie_app/screens/movie_detail_screen.dart'; // Assuming your MovieDetailScreen is here

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'movie-poster-${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterUrl,
                    width: 90,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 90,
                      height: 130,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star_rate_rounded, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.rating}',
                          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, color: Colors.grey[600], size: 18),
                        const SizedBox(width: 4),
                        Text(
                          movie.duration,
                          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.genre,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.releaseDate,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}