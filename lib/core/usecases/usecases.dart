import 'package:animewatchlist/core/errors/failures.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class WatchlistParams extends Equatable {
  const WatchlistParams(this.watchlist);

  final WatchlistModel watchlist;

  @override
  List<Object?> get props => throw UnimplementedError();
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => <dynamic>[];
}
