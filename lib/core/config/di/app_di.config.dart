// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:animewatchlist/features/watchlist/presentation/provider/watchlist_provider.dart'
    as _i824;
import 'package:animewatchlist/features/watchlist/watchlist.dart' as _i58;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i58.RemoteDatasource>(
    () => const _i58.RemoteDatasourceImpl(),
    instanceName: 'RemoteDatasourceImpl',
  );
  gh.factory<_i58.WatchlistRepository>(
    () => _i58.WatchlistRepositoryImpl(
        gh<_i58.RemoteDatasource>(instanceName: 'RemoteDatasourceImpl')),
    instanceName: 'WatchlistRepositoryImpl',
  );
  gh.lazySingleton<_i824.WatchlistProvider>(() => _i824.WatchlistProvider(
      gh<_i58.WatchlistRepository>(instanceName: 'WatchlistRepositoryImpl')));
  gh.factory<_i58.GetWatchlist>(() => _i58.GetWatchlist(
      gh<_i58.WatchlistRepository>(instanceName: 'WatchlistRepositoryImpl')));
  return getIt;
}
