import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {

  String _getFavoritesKey(String userId) => 'favorite_movies_$userId';



  Future<List<String>> getFavoriteMovieIds(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_getFavoritesKey(userId)) ?? [];
  }

  Future<void> addMovieToFavorites(String movieId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await getFavoriteMovieIds(userId);
    if (!currentFavorites.contains(movieId)) {
      currentFavorites.add(movieId);
      await prefs.setStringList(_getFavoritesKey(userId), currentFavorites);
    }
  }

  Future<void> removeMovieFromFavorites(String movieId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await getFavoriteMovieIds(userId);
    currentFavorites.remove(movieId);
    await prefs.setStringList(_getFavoritesKey(userId), currentFavorites);
  }
}
