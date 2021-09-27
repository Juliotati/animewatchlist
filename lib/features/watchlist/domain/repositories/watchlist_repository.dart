import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/features/watchlist/domain/entities/watchlist.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<Watchlist>>> getAllAnimes();
  Future<Either<Failure, Watchlist>> getDroppedAnimes();
  Future<Either<Failure, Watchlist>> getOnHoldAnimes();
  Future<Either<Failure, Watchlist>> getPlanToWatchAnimes();
  Future<Either<Failure, Watchlist>> getWatchedAnimes();
  Future<Either<Failure, Watchlist>> getWatchingAnimes();
}
