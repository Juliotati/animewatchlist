import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';

import 'datasource_watchlist.dart';

abstract class LocalDatasource {
  Future<List<WatchlistModel>> getAllAnimes();

  Future<WatchlistModel> getWatchingAnimes();

  Future<WatchlistModel> getOnHoldAnimes();

  Future<WatchlistModel> getPlanToWatchAnimes();

  Future<WatchlistModel> getDroppedAnimes();

  Future<WatchlistModel> getWatchedAnimes();
}

class LocalDatasourceImpl implements LocalDatasource {
  LocalDatasourceImpl._();

  static LocalDatasourceImpl instance = LocalDatasourceImpl._();

  late final AnimeWatchList source;

  @override
  Future<List<WatchlistModel>> getAllAnimes() async {
    try {
      final List<WatchlistModel> allAnimes = <WatchlistModel>[
        const WatchlistModel(folder: '', links: <String>['']),
        await getWatchingAnimes(),
        await getOnHoldAnimes(),
        await getPlanToWatchAnimes(),
        await getDroppedAnimes(),
        await getWatchedAnimes(),
      ];

      return allAnimes;
    } on AnimeWatchListException catch (_) {
      instance.source = AnimeWatchList.instance;
      await getAllAnimes();
      throw AnimeWatchListException(
          'Datasource has been automatically initialized, do initialize manually to avoid sever errors');
    }
  }

  @override
  Future<WatchlistModel> getWatchingAnimes() async {
    try {
      final Map<String, dynamic> onholdAnimes =
          source.watchlist.firstWhere((Map<String, dynamic> element) {
        return element['folder'] == AnimeFolder.watching;
      });
      return WatchlistModel.fromJson(onholdAnimes);
    } catch (e) {
      throw AnimeWatchListException();
    }
  }

  @override
  Future<WatchlistModel> getOnHoldAnimes() async {
    try {
      final Map<String, dynamic> onholdAnimes =
          source.watchlist.firstWhere((Map<String, dynamic> element) {
        return element['folder'] == AnimeFolder.onhold;
      });
      return WatchlistModel.fromJson(onholdAnimes);
    } catch (e) {
      throw AnimeWatchListException();
    }
  }

  @override
  Future<WatchlistModel> getPlanToWatchAnimes() async {
    try {
      final Map<String, dynamic> plannedAnimes =
          source.watchlist.firstWhere((Map<String, dynamic> element) {
        return element['folder'] == AnimeFolder.planned;
      });
      return WatchlistModel.fromJson(plannedAnimes);
    } catch (e) {
      throw AnimeWatchListException();
    }
  }

  @override
  Future<WatchlistModel> getDroppedAnimes() async {
    try {
      final Map<String, dynamic> droppedAnimes =
          source.watchlist.firstWhere((Map<String, dynamic> element) {
        return element['folder'] == AnimeFolder.dropped;
      });
      return WatchlistModel.fromJson(droppedAnimes);
    } catch (e) {
      throw AnimeWatchListException();
    }
  }

  @override
  Future<WatchlistModel> getWatchedAnimes() async {
    try {
      final Map<String, dynamic> watchedAnimes =
          source.watchlist.firstWhere((Map<String, dynamic> element) {
        return element['folder'] == AnimeFolder.watched;
      });
      return WatchlistModel.fromJson(watchedAnimes);
    } catch (e) {
      throw AnimeWatchListException();
    }
  }
}
