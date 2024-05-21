// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:animewatchlist/features/watchlist/presentation/provider/watchlist_provider.dart'
    as _i4;
import 'package:animewatchlist/features/watchlist/watchlist.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.RemoteDatasource>(
    () => const _i3.RemoteDatasourceImpl(),
    instanceName: 'RemoteDatasourceImpl',
  );
  gh.factory<_i3.WatchlistRepository>(
    () => _i3.WatchlistRepositoryImpl(
        gh<_i3.RemoteDatasource>(instanceName: 'RemoteDatasourceImpl')),
    instanceName: 'WatchlistRepositoryImpl',
  );
  gh.lazySingleton<_i4.WatchlistProvider>(() => _i4.WatchlistProvider(
      gh<_i3.WatchlistRepository>(instanceName: 'WatchlistRepositoryImpl')));
  gh.factory<_i3.GetWatchlist>(() => _i3.GetWatchlist(
      gh<_i3.WatchlistRepository>(instanceName: 'WatchlistRepositoryImpl')));
  return getIt;
}
