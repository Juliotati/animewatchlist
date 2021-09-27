import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/core/usecases/usecases.dart';
import 'package:animewatchlist/features/watchlist/domain/entities/watchlist.dart';
import 'package:animewatchlist/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:dartz/dartz.dart';

class GetWatchingAnimes implements UseCase<Watchlist, NoParams> {
  const GetWatchingAnimes(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, Watchlist>> call(NoParams params) async {
    return repository.getWatchingAnimes();
  }
}
