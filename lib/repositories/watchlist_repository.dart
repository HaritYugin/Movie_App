import 'package:shared_preferences/shared_preferences.dart';


class WatchlistRepository {

  String _getWatchlistKey(String userId) => 'watchlist_movies_$userId';



  Future<List<String>> getWatchlistMovieIds(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_getWatchlistKey(userId)) ?? [];
  }

  Future<void> addMovieToWatchlist(String movieId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentWatchlist = await getWatchlistMovieIds(userId);
    if (!currentWatchlist.contains(movieId)) {
      currentWatchlist.add(movieId);
      await prefs.setStringList(_getWatchlistKey(userId), currentWatchlist);
    }
  }

  Future<void> removeMovieFromWatchlist(String movieId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentWatchlist = await getWatchlistMovieIds(userId);
    currentWatchlist.remove(movieId);
    await prefs.setStringList(_getWatchlistKey(userId), currentWatchlist);
  }
}
