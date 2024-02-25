import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

import 'package:flutter/services.dart' show rootBundle;

class AnimeWatchList {
  const AnimeWatchList._();

  static const AnimeWatchList instance = AnimeWatchList._();

  Future<Map<String, dynamic>> watchlist() async {
    try {
      final watchlistJson = await rootBundle.loadString('anime_watchlist.json');
      if (watchlistJson.isEmpty) throw Exception('No watchlist found');

      log('LOADED "anime_watchlist.json" from assets');
      return jsonDecode(watchlistJson) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
