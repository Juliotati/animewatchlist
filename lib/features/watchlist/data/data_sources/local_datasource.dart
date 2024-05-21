import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/data_sources/watchlist.dart';
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
      final watchlist = await AnimeWatchList.instance.watchlist();
      return watchlist;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
