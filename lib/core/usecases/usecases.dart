import 'package:animewatchlist/core/core.dart';

abstract class UseCase<Type, Params> {
  Future<(AppException, Type)> call(Params params);
}

class NoParams {
  const NoParams();
}
