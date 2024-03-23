import 'package:json_annotation/json_annotation.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

part 'watchlist_category.g.dart';

@JsonSerializable(explicitToJson: true)
class WatchlistCategoryModel {
  WatchlistCategoryModel({
    this.link,
    this.name,
    this.id,
    this.addedAt,
    this.info,
  });

  factory WatchlistCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['mal'] != null) json['link'] = json['mal'];
    return _$WatchlistCategoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    final anime = WatchlistCategoryModel(
      id: idFromLink(link ?? info?.image ?? ''),
      link: link,
      name: displayName,
    );
    return _$WatchlistCategoryModelToJson(anime);
  }

  WatchlistCategoryModel copyWith({
    String? id,
    String? link,
    String? name,
    DateTime? addedAt,
    WebInfo? info,
  }) {
    return WatchlistCategoryModel(
      id: id ?? this.id,
      link: link ?? this.link,
      name: name ?? this.name,
      addedAt: addedAt ?? this.addedAt,
      info: info ?? this.info,
    );
  }

  String idFromLink(String link) {
    if (link.contains('images/')) return idFromInfoLink(link);
    return link.split('anime/').last.replaceAll('/', '');
  }

  String idFromInfoLink(String rawLink) {
    final linkParts = rawLink.split('/');
    final idIndex = linkParts.indexOf('anime') + 1;
    return linkParts[idIndex];
  }

  String get displayName {
    if (info?.title != null && info?.title.isNotEmpty == true) {
      return info!.title;
    }
    return name ?? '';
  }

  @JsonKey(includeIfNull: false)
  final String? id;

  @JsonKey(includeIfNull: false)
  final WebInfo? info;

  @JsonKey(includeIfNull: false)
  final String? name;

  @JsonKey(includeIfNull: false)
  final String? link;

  @JsonKey(includeIfNull: false)
  final DateTime? addedAt;
}
