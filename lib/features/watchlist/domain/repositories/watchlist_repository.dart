import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, WatchlistModel>> animeWatchlist();
}
