import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:flutter/services.dart' show rootBundle;

class AnimeWatchList {
  const AnimeWatchList._();

  static const AnimeWatchList instance = AnimeWatchList._();

  Future<WatchlistModel> watchlist() async {
    try {
      log('UPDATING WATCHLIST');
      const fileName = 'anime_watchlist.json';
      final encodedWatchlist = await rootBundle.loadString(fileName);

      if (encodedWatchlist.isEmpty) throw Exception('No watchlist found');
      log('LOADED watchlist');

      final watchlistMap = jsonDecode(encodedWatchlist) as Map<String, dynamic>;
      log('DECODED watchlist');

      return WatchlistModel.fromJson(watchlistMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
