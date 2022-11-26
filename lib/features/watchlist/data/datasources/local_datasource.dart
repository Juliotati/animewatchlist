import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';

import 'datasource_watchlist.dart';

abstract class LocalDatasource {
  Future<WatchlistModel> animeWatchlist();
}

class LocalDatasourceImpl implements LocalDatasource {
  LocalDatasourceImpl._();

  static LocalDatasourceImpl instance = LocalDatasourceImpl._();

  @override
  Future<WatchlistModel> animeWatchlist() async {
    try {
      return WatchlistModel.fromJson(AnimeWatchList.instance.watchlist);
    } catch (e) {
      throw AnimeWatchListException(e.toString());
    }
  }
}
