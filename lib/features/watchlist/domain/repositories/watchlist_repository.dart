import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';

abstract class WatchlistRepository {
  Future<(AppException, WatchlistModel)> animeWatchlist();
}
