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
      return WatchlistModel.fromJson(AnimeWatchList.instance.watchlist);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
