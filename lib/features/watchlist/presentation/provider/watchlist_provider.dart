import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/watchlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class WatchlistProvider extends ChangeNotifier {
  WatchlistProvider(@Named.from(WatchlistRepositoryImpl) this._repository) {
    _loadWatchlist();
  }

  final WatchlistRepository _repository;

  final PageController controller = PageController();

  late WatchlistModel _watchlistModel;
  late WatchlistModel _filteredWatchlistModel;

  WatchlistModel get watchlist => _filteredWatchlistModel;

  WatchlistState _state = WatchlistState.loading;

  WatchlistState get state => _state;

  void _updateState(WatchlistState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> _loadWatchlist() async {
    if (!_state.isReloading) _updateState(WatchlistState.loading);

    _watchlistModel = (await _repository.watchlist()).data;
    _filteredWatchlistModel = _watchlistModel;
    _checkIfEmpty();
  }

  Future<void> moveAnime({
    required WatchlistFolderType from,
    required WatchlistFolderType to,
    required WatchlistCategoryModel anime,
  }) async {
    await _repository.moveAnime(from: from, to: to, anime: anime);
  }

  Future<void> reloadWatchlist() {
    _updateState(WatchlistState.reloading);
    return _loadWatchlist();
  }

  void filterWatchlist(String query) {
    if (query.isEmpty) return _resetWatchlist();
    try {
      _filteredWatchlistModel = _watchlistModel.filterWatchlist(query);

      if (query.isEmpty) _resetWatchlist();

      return _updateState(WatchlistState.ready);
    } catch (error) {
      _updateState(WatchlistState.error);

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
      return _updateState(WatchlistState.empty);
    }
    _updateState(WatchlistState.ready);
  }

  void _resetWatchlist() {
    _filteredWatchlistModel = _watchlistModel;
    _updateState(WatchlistState.ready);
  }

  void goToPage(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
