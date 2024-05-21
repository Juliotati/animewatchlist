import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/watchlist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'watchlist.g.dart';

@JsonSerializable(explicitToJson: true)
class WatchlistModel {
  const WatchlistModel({
    required this.planned,
    required this.dropped,
    required this.onHold,
    required this.watched,
    required this.watching,
    required this.recommended,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return _$WatchlistModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WatchlistModelToJson(this);
  }

  List<WatchlistCategoryModel> folder(WatchlistFolderType folder) {
    return switch (folder) {
      WatchlistFolderType.planned => planned,
      WatchlistFolderType.dropped => dropped,
      WatchlistFolderType.onHold => onHold,
      WatchlistFolderType.watched => watched,
      WatchlistFolderType.watching => watching,
      WatchlistFolderType.recommended => recommended ?? [],
    };
  }

  @JsonKey(name: 'Planned')
  final List<WatchlistCategoryModel> planned;

  @JsonKey(name: 'Dropped')
  final List<WatchlistCategoryModel> dropped;

  @JsonKey(name: 'On-Hold')
  final List<WatchlistCategoryModel> onHold;

  @JsonKey(name: 'Watched')
  final List<WatchlistCategoryModel> watched;

  @JsonKey(name: 'Watching')
  final List<WatchlistCategoryModel> watching;

  @JsonKey(name: 'Recommended')
  final List<WatchlistCategoryModel>? recommended;
}
