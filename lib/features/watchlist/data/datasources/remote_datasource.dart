import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

interface class RemoteDatasource {
  Future<WatchlistModel> animeWatchlist() {
    throw UnimplementedError();
  }

  Future<void> updateWatchlist() {
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

      return watchlist;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> updateWatchlist() async {
    final watchlistJson = await AnimeWatchList.instance.watchlist();
    log('UPDATING WATCHLIST');
    final watchlist = WatchlistModel.fromJson(watchlistJson);

    for (final anime in watchlist.planned) {
      _updateHelper(AnimeFolderType.planned, anime);
    }

    for (final anime in watchlist.dropped) {
      _updateHelper(AnimeFolderType.dropped, anime);
    }
    for (final anime in watchlist.onHold) {
      _updateHelper(AnimeFolderType.onHold, anime);
    }

    for (final anime in watchlist.watching) {
      _updateHelper(AnimeFolderType.watching, anime);
    }

    for (final anime in watchlist.watched) {
      _updateHelper(AnimeFolderType.watched, anime);
    }

    for (final anime in watchlist.recommendedFromAll) {
      _updateHelper(AnimeFolderType.recommended, anime);
    }
    log('UPDATED WATCHLIST');
  }

  Future<void> _updateHelper(
    AnimeFolderType toFolder,
    WatchlistCategoryModel anime,
  ) async {
    try {
      final id = anime.idFromLink(anime.link ?? anime.info?.image ?? '');

      if (id.isEmpty) return;

      final path = '${toFolder.name}/$id';
      final exists = await _alreadyExistsOnCurrentFolder(path);

      if (exists) {
        log('$path ALREADY EXISTS');
        return;
      }

      bool movedFolder = false;
      for (final otherFolder in AnimeFolderType.values) {
        if (otherFolder == toFolder ||
            otherFolder.watchedFolder ||
            otherFolder.recommendedFolder) {
          log('SKIPPING ${otherFolder.name} FOLDER');
          continue;
        }

        final otherPath = '${otherFolder.name}/$id';
        final watchedPath = '${AnimeFolderType.watched.name}/$id';

        final existsElseWhere = await _alreadyExistsOnCurrentFolder(otherPath);
        final watched = await _alreadyExistsOnCurrentFolder(watchedPath);

        if (existsElseWhere && watched) {
          movedFolder = true;
          log('MOVING $id FROM ${otherFolder.name} to ${toFolder.name}');
          _firestore.doc(otherPath).delete();
          await _mergeDoc(path, anime.toJson());
        }
        movedFolder = false;
      }

      if (!movedFolder) {
        log('ADDING NEW: $path');
        final updatedAnime = anime.copyWith(addedAt: DateTime.now());
        await _mergeDoc(path, updatedAnime.toJson());
      }
      return;
    } catch (error) {
      log('$error');
    }
  }

  Future<void> _mergeDoc(String path, Map<String, dynamic> data) async {
    return _firestore.doc(path).set(data, SetOptions(merge: true));
  }

  Future<bool> _alreadyExistsOnCurrentFolder(String path) async {
    final exists = (await _firestore.doc(path).get()).exists;
    return exists;
  }

  @override
  Future<void> updateAnimeInfo(
    AnimeFolderType folder,
    String? id,
    WebInfo? info,
  ) async {
    if (info == null) return;
    if (id?.isEmpty == true) return;

    final blacklistTitles = [
      'MyAnimeList',
      'Human verification',
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
      _firestore.doc('${AnimeFolderType.watched.name}/$id').set(
        {'info': info.toJson()},
        SetOptions(merge: true),
      );
    }

    log('updated anime info[$id]: ${info.title}');
  }
}
