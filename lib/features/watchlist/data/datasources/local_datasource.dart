import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';

import 'datasource_watchlist.dart';

abstract class LocalDatasource {
  Future<List<WatchListModel>> getAllAnimes();

  Future<WatchListModel> getWatchingAnimes();

  Future<WatchListModel> getOnHoldAnimes();

  Future<WatchListModel> getPlanToWatch();

  Future<WatchListModel> getDroppedAnimes();

  Future<WatchListModel> getWatchedAnimes();
}

class LocalDatasourceImpl implements LocalDatasource {
  LocalDatasourceImpl._();

  static LocalDatasourceImpl instance = LocalDatasourceImpl._();

  late final AnimeWatchList source;

  @override
  Future<List<WatchListModel>> getAllAnimes() async {
    final List<WatchListModel> allAnimes = <WatchListModel>[
      const WatchListModel(folder: '',links: <String>['']),
      await getWatchingAnimes(),
      await getOnHoldAnimes(),
      await getPlanToWatch(),
      await getDroppedAnimes(),
      await getWatchedAnimes(),
    ];

    return allAnimes;
  }

  @override
  Future<WatchListModel> getWatchingAnimes() async {
    final Map<String, dynamic> onholdAnimes =
        source.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'watching';
    });
    return WatchListModel.fromJson(onholdAnimes);
  }

  @override
  Future<WatchListModel> getOnHoldAnimes() async {
    final Map<String, dynamic> onholdAnimes =
        source.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'onhold';
    });
    return WatchListModel.fromJson(onholdAnimes);
  }

  @override
  Future<WatchListModel> getPlanToWatch() async {
    final Map<String, dynamic> plannedAnimes =
        source.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'planned';
    });
    return WatchListModel.fromJson(plannedAnimes);
  }

  @override
  Future<WatchListModel> getDroppedAnimes() async {
    final Map<String, dynamic> droppedAnimes =
        source.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'dropped';
    });
    return WatchListModel.fromJson(droppedAnimes);
  }

  @override
  Future<WatchListModel> getWatchedAnimes() async {
    final Map<String, dynamic> watchedAnimes =
        source.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'watched';
    });
    return WatchListModel.fromJson(watchedAnimes);
  }
}
