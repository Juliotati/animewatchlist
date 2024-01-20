// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistCategoryModel _$WatchlistCategoryModelFromJson(
        Map<String, dynamic> json) =>
    WatchlistCategoryModel(
      link: json['link'] as String?,
      name: json['name'] as String?,
      id: json['id'] as String?,
      info: json['info'] == null
          ? null
          : WebInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WatchlistCategoryModelToJson(
    WatchlistCategoryModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('info', instance.info?.toJson());
  writeNotNull('name', instance.name);
  writeNotNull('link', instance.link);
  return val;
}
