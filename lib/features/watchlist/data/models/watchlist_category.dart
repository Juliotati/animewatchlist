import 'package:json_annotation/json_annotation.dart';

part 'watchlist_category.g.dart';

@JsonSerializable(explicitToJson: true)
class WatchlistCategoryModel {
  const WatchlistCategoryModel({
    required this.link,
    required this.name,
  });

  factory WatchlistCategoryModel.fromJson(Map<String, dynamic> json) {
    return _$WatchlistCategoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WatchlistCategoryModelToJson(this);
  }

  final String name;
  final String link;
}
