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
}
