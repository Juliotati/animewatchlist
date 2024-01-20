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
    final watchlist = WatchlistModel.fromJson(
      AnimeWatchList.instance.watchlist,
    );

    final recommendedList = WatchlistModel.fromJson(
      AnimeWatchList.instance.watchlist,
    ).recommendedFromAll;

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

    for (final anime in recommendedList) {
      _updateHelper(AnimeFolderType.recommended, anime);
    }
  }

  Future<void> _updateHelper(
    AnimeFolderType toFolder,
    WatchlistCategoryModel anime,
  ) async {
    try {
      final id = anime.idFromLink(anime.link ?? anime.info?.image ?? '');

      Future<bool> animeExists(String path) async {
        return (await _firestore.doc(path).get()).exists;
      }

      if (id.isEmpty) return;

      final path = '${toFolder.name}/$id';
      final exists = await animeExists(path);

      if (toFolder.watchedFolder && exists) {
        log('$path ALREADY EXISTS');
        return;
      }

      bool movedFolder = false;
      for (final otherFolder in AnimeFolderType.values) {
        if (otherFolder == toFolder || otherFolder.watchedFolder) {
          continue;
        }

        final otherPath = '${otherFolder.name}/$id';
        final watchedPath = '${AnimeFolderType.watched.name}/$id';

        final existsElseWhere = await animeExists(otherPath);
        final watched = await animeExists(watchedPath);

        if (!otherFolder.watchedFolder && existsElseWhere && watched) {
          if (!otherFolder.recommendedFolder) {
            movedFolder = true;
            log('MOVING $id FROM ${otherFolder.name} to ${toFolder.name}');
            _firestore.doc(otherPath).delete();
          }
        }
      }

      if (!movedFolder) log('ADDING NEW: $path');
      await _firestore.doc(path).set(anime.toJson(), SetOptions(merge: true));
      return;
    } catch (error) {
      log('$error');
    }
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
      'Ops could\'t get a title',
    ];

    if (blacklistTitles.any((title) => title == info.title)) {
      log('Preventing update on: ${info.title}');
      return;
    }

    _firestore.doc('${folder.name}/$id').set(
      {'info': info.toJson()},
      SetOptions(merge: true),
    );
    log('updated anime info[$id]: ${info.title}');
  }
}
