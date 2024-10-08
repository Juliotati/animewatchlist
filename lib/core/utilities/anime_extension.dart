part of '../core.dart';

extension AnimeExtension on WatchlistCategoryModel {
  bool get isRecommended {
    return _has('ajin') ||
        _has('91 Days') ||
        _has('arcane') ||
        _has('Attack on Titan') ||
        _has('berserk') ||
        _has('black lagoon') ||
        _has('blade of the immortal') ||
        _has('chainsaw man') ||
        _has('cyberpunk') ||
        _has('days') ||
        _has('death note') ||
        (_has('demon slayer') || _has('Kimetsu no Yaiba')) ||
        _has('dororo') ||
        _has('DRIFTERS') ||
        _has('gleipnir') ||
        _has('golden boy') ||
        _has('golden kamuy') ||
        _has('Fate/Zero') ||
        _has('Fighting Spirit:') ||
        _has('Frieren') ||
        _has('HAIKYU') ||
        _has('Hajime no Ippo') ||
        _has('Hell’s Paradise') ||
        _has('Hunter x Hunter') ||
        _has('i am what i am') ||
        _has('Is It Wrong to Try to Pick Up Girls in a Dungeon') ||
        _has('jujutsu kaisen') ||
        _has('jormungand') ||
        (_has('kingdom') && !_has('hero')) ||
        _has('Megalobox') ||
        _has('Monster') ||
        _has('Mushoku Tensei') ||
        _has('My Home Hero') ||
        (_has('naruto') && !_has('boruto')) ||
        _has('quintessential') ||
        _has('Ranking of Kings') ||
        _has('rent-a-girlfriend') ||
        _has('relife') ||
        _has('re:Zero') ||
        _has('Saga of Tanya the Evil') ||
        _has('shield hero') ||
        _has('Sword Art Online') ||
        _has('Sword of the Stranger') ||
        _has('That Time I Got Reincarnated as a Slime') ||
        _has('The Eminence in Shadow') ||
        _has('The God of High School') ||
        _has('to your eternity') ||
        _has('vinland saga') ||
        _has('your name') ||
        (_has('weathering with you') || _has('Tenki no Ko')) ||
        _has('World Trigger');
  }

  bool _has(String value) {
    return displayName.toLowerCase().contains(value.toLowerCase());
  }
}

extension AnimeWatchlistExtension on WatchlistModel {
  List<WatchlistCategoryModel> get recommendedFromAll {
    final List<WatchlistCategoryModel> recommendationList = [];
    recommendationList.addAll(watched.where((anime) => anime.isRecommended));
    recommendationList.addAll(watching.where((anime) => anime.isRecommended));
    recommendationList.addAll(planned.where((anime) => anime.isRecommended));
    recommendationList.addAll(onHold.where((anime) => anime.isRecommended));

    return sortByName(recommendationList);
  }

  List<WatchlistCategoryModel> get watchedAndRecommended {
    return sortByName(recommended?.toList());
  }

  bool _foundMatch(String? name, String query) {
    final neatName = (name ?? '').toLowerCase().trim();
    final neatQuery = query.toLowerCase().trim();

    if (neatName.isEmpty || neatQuery.isEmpty) return false;

    return neatName.startsWith(neatQuery) ||
        neatName.contains(neatQuery) ||
        neatName.endsWith(neatQuery);
  }

  WatchlistModel filterWatchlist(String query) {
    const int plannedIndex = 0;
    const int droppedIndex = 1;
    const int onHoldIndex = 2;
    const int watchedIndex = 3;
    const int watchingIndex = 4;
    const int recommendedIndex = 5;

    final List<List<WatchlistCategoryModel>> allWatchLists = [
      planned,
      dropped,
      onHold,
      watched,
      watching,
      recommendedFromAll,
    ];

    final List<List<WatchlistCategoryModel>> allWatchListsResults = [
      [],
      [],
      [],
      [],
      [],
      [],
    ];

    for (int i = 0; i <= recommendedIndex; i++) {
      for (final anime in allWatchLists[i]) {
        if (!_foundMatch(anime.displayName, query)) continue;
        allWatchListsResults[i].add(anime);
      }
    }

    return WatchlistModel(
      planned: allWatchListsResults[plannedIndex],
      dropped: allWatchListsResults[droppedIndex],
      onHold: allWatchListsResults[onHoldIndex],
      watched: allWatchListsResults[watchedIndex],
      watching: allWatchListsResults[watchingIndex],
      recommended: allWatchListsResults[recommendedIndex],
    );
  }

  List<WatchlistCategoryModel> get topAnime {
    final rawList = <WatchlistCategoryModel>[];
    final topAnimeIds = myTopAnimeIds.take(30);

    for (final anime in watchedAndRecommended) {
      if (!topAnimeIds.contains(anime.id)) continue;
      if (anime.id == null || anime.id == null) continue;

      rawList.add(anime);
      if (rawList.length == topAnimeIds.length) break;
    }

    final topList = <WatchlistCategoryModel>[];

    for (final id in topAnimeIds) {
      final anime = rawList.firstWhereOrNull((anime) => anime.id == id);
      if (anime == null) continue;
      topList.add(anime);
    }

    return topList;
  }
}

// dart format off
const List<String> myTopAnimeIds = [
  '20',     // 1.  Naruto
  '1735',   // 2.  Naruto Shippuden
  '12031',  // 3.  Kingdom
  '16498',  // 4.  Attack on Titan
  '19',     // 5.  Monster
  '37521',  // 6.  Vinland Saga
  '2418',   // 7.  Sword of the Stranger
  '39535',  // 8.  Mushoku Tensei: Jobless Reincarnation
  '52991',  // 9.  Frieren: Beyond Journey's End
  '38000',  // 10. Demon Slayer: Kimetsu no Yaiba
  '31240',  // 11. Re:ZERO -Starting Life in Another World-
  '37430',  // 12. That Time I Got Reincarnated as a Slime
  '268',    // 13. Golden boy
  '36028',  // 14. Golden Kamuy
  '30015',  // 15. ReLIFE
  '20583',  // 16. HAIKYU!!
  '30',     // 17. Bleach
  '136',    // 18. Hunter x Hunter
  '44511',  // 19. Chainsaw man
  '21',     // 20. One Piece
  '48316',  // 21. The Eminence in Shadow
  '32494',  // 22. DAYS
  '889',    // 23. Black Lagoon
  '263',    // 24. Hajime no Ippo
  '32615',  // 25. Saga of Tanya the Evil
  '24405',  // 26. World Trigger
  '52769',  // 27. I Am What I Am
  '32281',  // 28. Your Name
  '38826',  // 29. Weathering with You
  '40834',  // 30. Ranking of Kings
];
// dart format on

List<WatchlistCategoryModel> sortByName(List<WatchlistCategoryModel>? data) {
  if (data == null || data.isEmpty) return [];
  return data
    ..sort((a, b) {
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    })
    ..toList();
}

extension ListExt<E> on Iterable<E> {
  E get randomElement {
    final random = math.Random();
    final int index = random.nextInt(length);
    return elementAt(index);
  }
}
