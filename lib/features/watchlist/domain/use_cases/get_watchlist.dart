part of '../../watchlist.dart';

@injectable
final class GetWatchlist implements UseCase<WatchlistModel, NoParams> {
  const GetWatchlist(@Named.from(WatchlistRepositoryImpl) this._repository);

  final WatchlistRepository _repository;

  @override
  Future<WatchlistResult> call(NoParams params) async {
    return _repository.watchlist();
  }
}
