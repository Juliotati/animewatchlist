// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistModel _$WatchListModelFromJson(Map<String, dynamic> json) {
  return WatchlistModel(
    folder: json['folder'] as String,
    links: (json['links'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$WatchListModelToJson(WatchlistModel instance) =>
    <String, dynamic>{
      'folder': instance.folder,
      'links': instance.links,
    };
