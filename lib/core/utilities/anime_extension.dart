part of '../core.dart';

extension AnimeExtension on WatchlistCategoryModel {
  bool get isRecommended {
    return _has('ajin') ||
        _has('91 Days') ||
        _has('arcane') ||
        _has('Attack on Titan') ||
        _has('attack on titan') ||
        _has('baki') ||
        _has('berserk') ||
        _has('black lagoon') ||
        _has('blade of the immortal') ||
        _has('bleach') ||
        _has('certain scientific') ||
        _has('chainsaw man') ||
        _has('cyberpunk') ||
        _has('days') ||
        _has('death note') ||
        _has('demon slayer') ||
        _has('dororo') ||
        _has('DRIFTERS') ||
        _has('gleipnir') ||
        _has('golden boy') ||
        _has('golden kamuy') ||
        _has('Fate/Zero') ||
        _has('Fighting Spirit:') ||
        _has('Hajime no Ippo') ||
        _has('Hunter x Hunter') ||
        _has('Hell’s Paradise') ||
        _has('i am what i am') ||
        _has('Is It Wrong to Try to Pick Up Girls in a Dungeon') ||
        _has('jujutsu kaisen') ||
        _has('jormungand') ||
        (_has('kingdom') && !_has('hero')) ||
        _has('Megalobox') ||
        _has('Mob Psycho') ||
        _has('Mushoku Tensei') ||
        _has('My Home Hero') ||
        (_has('naruto') && !_has('boruto')) ||
        _has('overlord') ||
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
        _has('tower of god') ||
        _has('vinland saga') ||
        _has('your name') ||
        _has('weathering with you') ||
        _has('World Trigger');
  }

  bool _has(String value) {
    return name.toLowerCase().contains(value.toLowerCase());
  }
}

extension AnimeWatchlistExtension on WatchlistModel {
  List<WatchlistCategoryModel> get recommended {
    final List<WatchlistCategoryModel> recommendationList = [];
    recommendationList.addAll(watched.where((anime) => anime.isRecommended));
    recommendationList.addAll(watching.where((anime) => anime.isRecommended));
    recommendationList.addAll(planned.where((anime) => anime.isRecommended));
    recommendationList.addAll(onHold.where((anime) => anime.isRecommended));

    return sortByName(recommendationList);
  }
}

List<WatchlistCategoryModel> sortByName(List<WatchlistCategoryModel>? data) {
  if (data == null || data.isEmpty) return [];
  return data
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
    ..toList();
}
