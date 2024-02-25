import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';

abstract class LocalDatasource {
  Future<WatchlistModel> animeWatchlist();
}

class LocalDatasourceImpl implements LocalDatasource {
  LocalDatasourceImpl._();

  static LocalDatasourceImpl instance = LocalDatasourceImpl._();

  @override
  Future<WatchlistModel> animeWatchlist() async {
    try {
      final watchlistJson = await AnimeWatchList.instance.watchlist();
      return WatchlistModel.fromJson(watchlistJson);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
