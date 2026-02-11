part of '../../watchlist.dart';

@named
@Injectable(as: WatchlistRepository)
final class WatchlistRepositoryImpl implements WatchlistRepository {
  WatchlistRepositoryImpl(@Named.from(RemoteDatasourceImpl) this._datasource);

  final RemoteDatasource _datasource;

  @override
  Future<WatchlistResult> watchlist() async {
    try {
      final watchlist = await _datasource.watchlist();
      return (exception: null, data: watchlist);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> moveAnime({
    required WatchlistFolderType from,
    required WatchlistFolderType to,
    required WatchlistCategoryModel anime,
  }) async {
    await _datasource.moveAnime(from: from, to: to, anime: anime);
  }
}
