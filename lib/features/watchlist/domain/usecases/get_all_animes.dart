import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/core/usecases/usecases.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:dartz/dartz.dart';

class GetAnimeWatchlist implements UseCase<WatchlistModel, NoParams> {
  const GetAnimeWatchlist(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, WatchlistModel>> call(NoParams params) async {
    return repository.animeWatchlist();
  }
}
