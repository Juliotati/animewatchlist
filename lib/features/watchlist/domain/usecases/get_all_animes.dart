import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/core/usecases/usecases.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/domain/repositories/watchlist_repository.dart';

class GetAnimeWatchlist implements UseCase<WatchlistModel, NoParams> {
  const GetAnimeWatchlist(this.repository);

  final WatchlistRepository repository;

  @override
  Future<(AppException, WatchlistModel)> call(NoParams params) async {
    return repository.animeWatchlist();
  }
}
