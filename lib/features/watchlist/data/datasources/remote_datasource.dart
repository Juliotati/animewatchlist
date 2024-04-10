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

@named
@Injectable(as: RemoteDatasource)
class RemoteDatasourceImpl implements RemoteDatasource {
  const RemoteDatasourceImpl();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final _visitedAnimeCache =
      <String?, ({WatchlistCategoryModel? anime, AnimeFolderType? folder})?>{};

  @override
  Future<WatchlistModel> animeWatchlist() async {
    try {
      log('getting watchlist');

      final plannedFolder = await _firestore.collection('Planned').get();
      final droppedFolder = await _firestore.collection('Dropped').get();
      final onHoldFolder = await _firestore.collection('On-Hold').get();
      final watchedFolder = await _firestore.collection('Watched').get();
      final watchingFolder = await _firestore.collection('Watching').get();
      final recommendedFolder =
          await _firestore.collection('Recommended').get();

      log('loaded watchlist');

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

      log('built watchlist model');
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
          continue;
        }

        if (isNewAnime) {
          log('ADDING NEW ANIME: $currentAnimeId');
          await _mergeDoc(
            '${folder.name}/$currentAnimeId',
            currentAnime.copyWith(addedAt: DateTime.now()).toJson(),
          );
          continue;
        }

        final noFolderChange = oldItem.folder == folder;
        if (noFolderChange) {
          log('SKIPPING: $currentAnimeId');
          continue;
        }

        final oldAnime = oldItem.anime;
        if (oldAnime == null) {
          log('COULD NOT MOVE NULL ANIME: $currentAnimeId');
          continue;
        }

        log('MOVING: $currentAnimeId FROM ${oldItem.folder} TO $folder');
        _mergeDoc(
          '${folder.name}/$currentAnimeId',
          oldAnime.copyWith(addedAt: DateTime.now()).toJson(),
        );

        _firestore.doc('${oldItem.folder?.name}/$currentAnimeId').delete();

        if (oldAnime.isRecommended) {
          if (currentAnimeId.isEmpty) continue;
          const recommendedFolder = AnimeFolderType.recommended;

          _mergeDoc(
            '$recommendedFolder/$currentAnimeId',
            oldAnime.copyWith(addedAt: DateTime.now()).toJson(),
          );
          _firestore.doc('$recommendedFolder/$currentAnimeId').set(
            {'info': oldAnime.info?.toJson()},
            SetOptions(merge: true),
          );
        }
      }
    }
    log('UPDATED WATCHLIST');
  }

  ({WatchlistCategoryModel? anime, AnimeFolderType? folder}) _animeExists(
    WatchlistCategoryModel currentAnime,
    WatchlistModel newWatchlist,
  ) {
    final animeId = currentAnime.idFromLink(currentAnime.link ?? '');

    if (_visitedAnimeCache.containsKey(animeId)) {
      final animeCache = _visitedAnimeCache[animeId];
      if (animeCache != null && animeCache.anime != null) {
        log('_visitedAnimeCache CACHE HIT: $animeId');
        return animeCache;
      }
    }

    for (final folder in AnimeFolderType.values) {
      if (folder == AnimeFolderType.recommended) continue;
      final newFolderWatchlist = newWatchlist.folder(folder);

      for (final anime in newFolderWatchlist) {
        if (anime.id == animeId) {
          _visitedAnimeCache[animeId] = (
            anime: anime,
            folder: folder,
          );
          log('newWatchlist CACHE HIT: $animeId');
          return (anime: anime, folder: folder);
        }
      }
    }

    log('CACHE MISS: $animeId');
    return (anime: null, folder: null);
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

    log('updated anime info[$id]: ${info.title}');
  }
}
