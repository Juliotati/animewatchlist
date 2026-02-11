part of '../../watchlist.dart';

typedef WatchlistResult = ({AppException? exception, WatchlistModel data});

abstract class WatchlistRepository {
  Future<WatchlistResult> watchlist() {
    throw UnimplementedError();
  }

  Future<void> moveAnime({
    required WatchlistFolderType from,
    required WatchlistFolderType to,
    required WatchlistCategoryModel anime,
  }) {
    throw UnimplementedError();
  }
}
