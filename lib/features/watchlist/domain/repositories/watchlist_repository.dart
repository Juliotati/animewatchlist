part of '../../watchlist.dart';

typedef WatchlistResult = ({AppException? exception, WatchlistModel data});

abstract class WatchlistRepository {
  Future<WatchlistResult> watchlist() async {
    throw UnimplementedError();
  }
}
