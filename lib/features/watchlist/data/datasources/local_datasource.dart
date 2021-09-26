import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';

import 'datasource_watchlist.dart';

abstract class LocalDatasource {
  Future<List<WatchListModel>> getAllAnimes();

  Future<WatchListModel> getWatchingAnimes();

  Future<WatchListModel> getPlanToWatch();

  Future<WatchListModel> getWatchedAnimes();

  Future<WatchListModel> getDroppedAnimes();

  Future<WatchListModel> getOnHoldAnimes();
}

class LocalDatasourceImpl implements LocalDatasource {
  LocalDatasourceImpl([this.source]);

  static final LocalDatasourceImpl instance = LocalDatasourceImpl();

  final AnimeWatchList? source;

  @override
  Future<List<WatchListModel>> getAllAnimes() async {
    final List<WatchListModel> allAnimes = <WatchListModel>[
      await getWatchedAnimes(),
      await getDroppedAnimes(),
      await getOnHoldAnimes(),
      await getPlanToWatch(),
      await getWatchingAnimes(),
    ];

    return allAnimes;
  }

  @override
  Future<WatchListModel> getWatchedAnimes() async {
    final Map<String, dynamic> watchedAnimes =
        source!.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'watched';
    });
    return WatchListModel.fromJson(watchedAnimes);
  }

  @override
  Future<WatchListModel> getDroppedAnimes() async {
    final Map<String, dynamic> droppedAnimes =
        source!.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'dropped';
    });
    return WatchListModel.fromJson(droppedAnimes);
  }

  @override
  Future<WatchListModel> getPlanToWatch() async {
    final Map<String, dynamic> plannedAnimes =
        source!.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'planned';
    });
    return WatchListModel.fromJson(plannedAnimes);
  }

  @override
  Future<WatchListModel> getOnHoldAnimes() async {
    final Map<String, dynamic> onholdAnimes =
        source!.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'onhold';
    });
    return WatchListModel.fromJson(onholdAnimes);
  }

  @override
  Future<WatchListModel> getWatchingAnimes() async {
    final Map<String, dynamic> onholdAnimes =
        source!.watchlist.firstWhere((Map<String, dynamic> element) {
      return element['folder'] == 'watching';
    });
    return WatchListModel.fromJson(onholdAnimes);
  }
}
