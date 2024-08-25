part of '../../watchlist.dart';

class AnimeWatchList {
  const AnimeWatchList._();

  static const AnimeWatchList instance = AnimeWatchList._();

  Future<WatchlistModel> watchlist() async {
    try {
      log(name: 'cache', 'UPDATING: WATCHLIST');
      const fileName = 'anime_watchlist.json';
      final encodedWatchlist = await rootBundle.loadString(fileName, cache: false);

      if (encodedWatchlist.isEmpty) throw Exception('No watchlist found');
      log(name: 'cache', 'LOADED: WATCHLIST');

      final watchlistMap = jsonDecode(encodedWatchlist) as Map<String, dynamic>;
      log(name: 'cache', 'DECODED: WATCHLIST');

      return WatchlistModel.fromJson(watchlistMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
