part of '../../watchlist.dart';

abstract class LocalDatasource {
  Future<WatchlistModel> watchlist();
}

final class LocalDatasourceImpl implements LocalDatasource {
  const LocalDatasourceImpl._();

  static const LocalDatasourceImpl instance = LocalDatasourceImpl._();

  @override
  Future<WatchlistModel> watchlist() async {
    try {
      final watchlist = await AnimeWatchList.instance.watchlist();
      return watchlist;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
