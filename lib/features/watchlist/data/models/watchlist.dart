import 'package:animewatchlist/features/watchlist/domain/entities/watchlist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'watchlist.g.dart';

@JsonSerializable(explicitToJson: true)
class WatchlistModel extends Watchlist {
  const WatchlistModel({
    required this.folder,
    required this.links,
  }) : super(
          folder: folder,
          links: links,
        );

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return _$WatchListModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WatchListModelToJson(this);
  }

  @override
  final String folder;
  @override
  final List<String> links;
}
