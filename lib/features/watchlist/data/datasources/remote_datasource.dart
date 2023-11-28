import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class RemoteDatasourceImpl implements RemoteDatasource {
  RemoteDatasourceImpl();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<WatchlistModel> animeWatchlist() async {
    try {
      log('getting watchlist');

      final plannedResponse = await _firestore.collection('Planned').get();
      final droppedResponse = await _firestore.collection('Dropped').get();
      final onHoldResponse = await _firestore.collection('On-Hold').get();
      final watchedResponse = await _firestore.collection('Watched').get();
      final watchingResponse = await _firestore.collection('Watching').get();

      log('loaded watchlist');

      final planned = plannedResponse.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final dropped = droppedResponse.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final onHold = onHoldResponse.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final watched = watchedResponse.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      final watching = watchingResponse.docs.map((animeMap) {
        return WatchlistCategoryModel.fromJson(animeMap.data());
      });

      log('fetched watchlist');
      final watchlist = WatchlistModel(
        planned: sortByName(planned.toList()),
        dropped: sortByName(dropped.toList()),
        onHold: sortByName(onHold.toList()),
        watched: sortByName(watched.toList()),
        watching: sortByName(watching.toList()),
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
    ).recommended;

    for (final anime in watchlist.planned) {
      _updateHelper(AnimeFolderType.planned, anime);
    }

    for (final anime in watchlist.dropped) {
      _updateHelper(AnimeFolderType.dropped, anime);
    }
    for (final anime in watchlist.onHold) {
      _updateHelper(AnimeFolderType.onHold, anime);
    }

    for (final anime in watchlist.watched) {
      _updateHelper(AnimeFolderType.watched, anime);
    }

    for (final anime in watchlist.watching) {
      _updateHelper(AnimeFolderType.watching, anime);
    }

    for (final anime in recommendedList) {
      _updateHelper(AnimeFolderType.recommended, anime);
    }
  }

  void _updateHelper(AnimeFolderType folder, WatchlistCategoryModel anime) {
    try {
      final id = anime.idFromLink(anime.link ?? anime.info?.image ?? '');
      final path = '${folder.name}/$id';

      log(path);

      if (id.isEmpty) return;

      _firestore.doc(path).set(
            anime.toJson(),
            SetOptions(merge: true),
          );
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

    _firestore.doc('${folder.name}/$id').set(
      {'info': info.toJson()},
      SetOptions(merge: true),
    );
  }
}
