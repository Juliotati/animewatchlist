import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/remote_datasource.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

enum AnimeState {
  error,
  loading,
  reloading,
  ready,
  empty;

  const AnimeState();

  bool get isLoading => this == loading;
  bool get isReloading => this == reloading;
  bool get showLoading => this == loading || this == reloading;
  bool get isReady => this == ready;
  bool get hasError => this == error;
  bool get notData => this == empty;
}

@lazySingleton
final class AnimeProvider extends ChangeNotifier {
  AnimeProvider(
    @Named.from(RemoteDatasourceImpl) this._remoteDatasource,
  ) {
    _loadWatchlist();
  }

  final PageController controller = PageController();

  final RemoteDatasource _remoteDatasource;

  late WatchlistModel _watchlistModel;
  late WatchlistModel _filteredWatchlistModel;

  WatchlistModel get watchlist => _filteredWatchlistModel;

  AnimeState _state = AnimeState.loading;

  AnimeState get state => _state;

  void _updateState(AnimeState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> _loadWatchlist() async {
    if (!_state.isReloading) _updateState(AnimeState.loading);

    _watchlistModel = await _remoteDatasource.animeWatchlist();
    _filteredWatchlistModel = _watchlistModel;
    _checkIfEmpty();
  }

  Future<void> reloadWatchlist() async {
    _updateState(AnimeState.reloading);
    return _loadWatchlist();
  }

  void filterWatchlist(String query) {
    if (query.isEmpty) return _resetWatchlist();
    try {
      _filteredWatchlistModel = _watchlistModel.filterWatchlist(query);

      if (query.isEmpty) _resetWatchlist();

      return _updateState(AnimeState.ready);
    } catch (error) {
      _updateState(AnimeState.error);

      log('FILTER ERROR: $error');
      return _resetWatchlist();
    }
  }

  void _checkIfEmpty() {
    final planned = _watchlistModel.planned;
    final watching = _watchlistModel.watching;
    final onHold = _watchlistModel.onHold;
    final dropped = _watchlistModel.dropped;
    final watched = _watchlistModel.watched;
    final recommended = _watchlistModel.recommended ?? [];

    if (planned.isEmpty &&
        watching.isEmpty &&
        onHold.isEmpty &&
        dropped.isEmpty &&
        watched.isEmpty &&
        recommended.isEmpty) {
      return _updateState(AnimeState.empty);
    }
    _updateState(AnimeState.ready);
  }

  void _resetWatchlist() {
    _filteredWatchlistModel = _watchlistModel;
    _updateState(AnimeState.ready);
  }
}
