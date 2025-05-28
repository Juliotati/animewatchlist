// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistModel _$WatchlistModelFromJson(
  Map<String, dynamic> json,
) => WatchlistModel(
  planned: (json['Planned'] as List<dynamic>)
      .map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  dropped: (json['Dropped'] as List<dynamic>)
      .map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  onHold: (json['On-Hold'] as List<dynamic>)
      .map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  watched: (json['Watched'] as List<dynamic>)
      .map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  watching: (json['Watching'] as List<dynamic>)
      .map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  recommended: (json['Recommended'] as List<dynamic>?)
      ?.map((e) => WatchlistCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WatchlistModelToJson(WatchlistModel instance) =>
    <String, dynamic>{
      'Planned': instance.planned.map((e) => e.toJson()).toList(),
      'Dropped': instance.dropped.map((e) => e.toJson()).toList(),
      'On-Hold': instance.onHold.map((e) => e.toJson()).toList(),
      'Watched': instance.watched.map((e) => e.toJson()).toList(),
      'Watching': instance.watching.map((e) => e.toJson()).toList(),
      'Recommended': instance.recommended?.map((e) => e.toJson()).toList(),
    };
