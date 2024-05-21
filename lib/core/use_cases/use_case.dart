import 'package:animewatchlist/features/watchlist/watchlist.dart';

abstract class UseCase<Type, Params> {
  Future<WatchlistResult> call(Params params);
}

class NoParams {
  const NoParams();
}
