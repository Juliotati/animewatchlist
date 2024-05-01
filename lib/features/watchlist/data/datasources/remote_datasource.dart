import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

interface class RemoteDatasource {
  Future<WatchlistModel> animeWatchlist() {
    throw UnimplementedError();
  }

  /// [newWatchlist] is in cache (.json), oldWatchlist is on remote database and
  /// [oldWatchlist] needs to be updated to match newWatchlist.

  /// Some anime will need to be moved from one folder to another without losing
  /// data.
  /// Meaning [oldWatchlist] anime data should be present within [newWatchlist]
  /// when it changes folder.
  /// after moving an anime to a new folder, delete the duplicate in anime in
  /// [oldWatchlist].
  ///
  /// If an anime is new, only add it to the [newWatchlist].
  /// If an anime is in the same folder, do nothing.
  Future<void> updateWatchlist(WatchlistModel oldWatchlist) {
    throw UnimplementedError();
  }

  Future<void> updateAnimeInfo(
    AnimeFolderType folder,
    String id,
    WebInfo? info,
  ) {
    throw UnimplementedError();
  }
}

typedef _SeenAnime = ({
  WatchlistCategoryModel? anime,
  AnimeFolderType? folder,
  bool blacklisted
});

@named
@Injectable(as: RemoteDatasource)
class RemoteDatasourceImpl implements RemoteDatasource {
  const RemoteDatasourceImpl();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final _visitedAnimeCache = <String?, _SeenAnime?>{};

  static int animeRemovedFromRecommendedCount = 0;
  static int newAnimeAddedCount = 0;
  static int animeMovedCount = 0;
  static int animeSkippedCount = 0;
  static int animeWithoutIdCount = 0;
  static int animeBlacklistedCount = 0;
  static int animeThatCouldNotBeMovedCount = 0;
  static int animeWithoutAddedAtCount = 0;

  void _resetCounters() {
    log('=============== RESULTS ===============');
    log('RemovedFromRecommended: $animeRemovedFromRecommendedCount');
    log('NewAnime: $newAnimeAddedCount');
    log('Moved: $animeMovedCount');
    log('Skipped: $animeSkippedCount');
    log('AnimeWithoutId: $animeWithoutIdCount');
    log('Blacklisted: $animeBlacklistedCount');
    log('CouldNotBeMoved: $animeThatCouldNotBeMovedCount');
    log('WithoutAddedAt: $animeWithoutAddedAtCount');
    log('=============== END ===============');

    animeRemovedFromRecommendedCount = 0;
    newAnimeAddedCount = 0;
    animeMovedCount = 0;
    animeSkippedCount = 0;
    animeWithoutIdCount = 0;
    animeBlacklistedCount = 0;
    animeThatCouldNotBeMovedCount = 0;
  }

  @override
  Future<WatchlistModel> animeWatchlist() async {
    try {
      log('GETTING WATCHLIST');

      final plannedFolder = await _firestore.collection('Planned').get();
      final droppedFolder = await _firestore.collection('Dropped').get();
      final onHoldFolder = await _firestore.collection('On-Hold').get();
      final watchedFolder = await _firestore.collection('Watched').get();
      final watchingFolder = await _firestore.collection('Watching').get();
      final recommendedFolder =
          await _firestore.collection('Recommended').get();

      log('LOADED WATCHLIST');

      final planned = plannedFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final dropped = droppedFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final onHold = onHoldFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final watched = watchedFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final watching = watchingFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final recommended = recommendedFolder.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      log('fetched watchlist');
      final watchlist = WatchlistModel(
        planned: sortByName(planned.toList()),
        dropped: sortByName(dropped.toList()),
        onHold: sortByName(onHold.toList()),
        watched: sortByName(watched.toList()),
        watching: sortByName(watching.toList()),
        recommended: sortByName(recommended.toList()),
      );

      log('BUILT WATCHLIST MODEL');
      updateWatchlist(watchlist);

      return watchlist;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> updateWatchlist(WatchlistModel oldWatchlist) async {
    if (!kDebugMode) {
      log('updateWatchlist IS DISABLED IN RELEASE MODE');
      return;
    }

    final newWatchlist = await AnimeWatchList.instance.watchlist();

    for (final folder in AnimeFolderType.values) {
      if (folder.recommendedFolder) continue;
      final newFolderWatchlist = newWatchlist.folder(folder);

      for (final currentAnime in newFolderWatchlist) {
        final oldItem = _animeExists(currentAnime, oldWatchlist);
        final isNewAnime = oldItem.anime == null;
        final currentAnimeId = currentAnime.idFromLink(currentAnime.link ?? '');

        if (currentAnimeId.isEmpty) {
          log('EMPTY ID ON: ${currentAnime.name}');
          animeWithoutIdCount++;
          continue;
        }

        final oldAnime = oldItem.anime;
        final oldAnimeId = oldAnime?.id;
        if (oldItem.blacklisted) {
          log('BLACKLISTED: $oldAnimeId');
          animeBlacklistedCount++;
          _firestore.doc('${oldItem.folder?.name}/$oldAnimeId').delete();
          if (oldAnime?.isRecommended == true) {
            _firestore.doc('Recommended/$oldAnimeId').delete();
            log('REMOVED: ${oldAnime?.name} FROM RECOMMENDED');
            animeRemovedFromRecommendedCount++;
          }
          continue;
        }

        if (isNewAnime) {
          log('ADDING NEW ANIME: $currentAnimeId');
          newAnimeAddedCount++;
          await _mergeDoc(
            '${folder.name}/$currentAnimeId',
            currentAnime.copyWith(addedAt: DateTime.now()).toJson(),
          );
          continue;
        }

        if (oldAnime == null) {
          log('COULD NOT MOVE NULL ANIME: $oldAnimeId');
          animeThatCouldNotBeMovedCount++;
          continue;
        }

        final addedAt = oldAnime.addedAt ?? DateTime.now();
        final noFolderChange = oldItem.folder == folder;

        if (noFolderChange) {
          log('SKIPPING: $currentAnimeId');
          animeSkippedCount++;
          if (oldAnime.addedAt == null) {
            log('ADDING MISSING "addedAt": $currentAnimeId');
            final updatedAnime = oldAnime.copyWith(addedAt: addedAt);

            _mergeDoc('${folder.name}/$currentAnimeId', updatedAnime.toJson());
            animeWithoutAddedAtCount++;
          }

          continue;
        }

        log('MOVING: $currentAnimeId FROM ${oldItem.folder} TO $folder');
        final updatedAnime = oldAnime.copyWith(addedAt: addedAt);
        _mergeDoc('${folder.name}/$currentAnimeId', updatedAnime.toJson());

        animeMovedCount++;
        _firestore.doc('${oldItem.folder?.name}/$currentAnimeId').delete();

        if (oldAnime.isRecommended) {
          if (currentAnimeId.isEmpty) continue;
          final recommendedFolder = AnimeFolderType.recommended.name;

          _mergeDoc(
            '$recommendedFolder/$currentAnimeId',
            oldAnime.copyWith(addedAt: addedAt).toJson(),
          );
          _firestore.doc('$recommendedFolder/$currentAnimeId').set(
            {'info': oldAnime.info?.toJson()},
            SetOptions(merge: true),
          );
        }
      }
    }
    _resetCounters();
    log('UPDATED WATCHLIST');
  }

  _SeenAnime _animeExists(
    WatchlistCategoryModel newAnime,
    WatchlistModel oldWatchlist,
  ) {
    final newAnimeId = newAnime.idFromLink(newAnime.link ?? '');

    if (_visitedAnimeCache.containsKey(newAnimeId)) {
      final animeCache = _visitedAnimeCache[newAnimeId];
      if (animeCache != null && animeCache.anime != null) {
        log('_visitedAnimeCache CACHE HIT: $newAnimeId');
        return animeCache;
      }
    }

    for (final folder in AnimeFolderType.values) {
      if (folder == AnimeFolderType.recommended) continue;
      final oldFolderWatchlist = oldWatchlist.folder(folder);

      for (final anime in oldFolderWatchlist) {
        if (anime.id == newAnimeId) {
          final isBlacklisted = _blacklistedIds.contains(anime.id);
          _visitedAnimeCache[newAnimeId] = (
            anime: anime,
            folder: folder,
            blacklisted: isBlacklisted,
          );
          log('CACHE HIT: $newAnimeId');
          return (anime: anime, folder: folder, blacklisted: isBlacklisted);
        }
      }
    }

    log('CACHE MISS: $newAnimeId');
    return (anime: null, folder: null, blacklisted: false);
  }

  List<String> get _blacklistedIds {
    return [
      '48745',
    ];
  }

  Future<void> _mergeDoc(String path, Map<String, dynamic> data) async {
    return _firestore.doc(path).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> updateAnimeInfo(
    AnimeFolderType folder,
    String? id,
    WebInfo? info,
  ) async {
    if (id == null || id.isEmpty || info == null) return;

    final blacklistTitles = [
      'MyAnimeList',
      'Human verification',
      '404 Not Found - MyAnimeList.net',
      'Ops could\'t get a title',
    ];

    String noCase(String text) => text.toLowerCase();
    if (blacklistTitles.any((title) => noCase(title) == noCase(info.title))) {
      log('Preventing update on: ${info.title}');
      return;
    }

    _firestore.doc('${folder.name}/$id').set(
      {'info': info.toJson()},
      SetOptions(merge: true),
    );

    if (folder.recommendedFolder) {
      // Update info on watched folder if recommended happens to load it first
      _firestore.doc('${AnimeFolderType.watched.name}/$id').set(
        {'info': info.toJson()},
        SetOptions(merge: true),
      );
    }

    log('UPDATED ANIME INFO[$id]: ${info.title}');
  }
}
