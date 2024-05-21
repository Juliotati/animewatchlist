part of '../../watchlist.dart';

enum WatchlistState {
  error,
  loading,
  reloading,
  ready,
  empty;

  const WatchlistState();

  bool get isLoading => this == loading;

  bool get isReloading => this == reloading;

  bool get showLoading => this == loading || this == reloading;

  bool get isReady => this == ready;

  bool get hasError => this == error;

  bool get notData => this == empty;

  String get stateMessage {
    return switch (this) {
      error => 'ERROR - COULD NOT LOAD WATCHLIST 🥲',
      loading => 'LOADING...',
      reloading => 'RELOADING...',
      ready => 'READY',
      empty => 'WATCHLIST IS EMPTY 😳',
    };
  }

  String get stateImage {
    return switch (this) {
      error => Assets.loadingGifs.luffySearch.path,
      loading => Assets.loadingGifs.values.randomElement.path,
      reloading => '',
      ready => '',
      empty => Assets.loadingGifs.luffySearch.path,
    };
  }
}
