import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/core/usecases/usecases.dart';
import 'package:animewatchlist/features/watchlist/domain/entities/watchlist.dart';
import 'package:animewatchlist/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:dartz/dartz.dart';

class GetOnHoldAnimes implements UseCase<Watchlist, NoParams> {
  const GetOnHoldAnimes(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, Watchlist>> call(NoParams params) async {
    return repository.getOnHoldAnimes();
  }
}
