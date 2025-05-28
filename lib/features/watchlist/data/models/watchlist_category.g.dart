// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistCategoryModel _$WatchlistCategoryModelFromJson(
  Map<String, dynamic> json,
) => WatchlistCategoryModel(
  link: json['link'] as String?,
  name: json['name'] as String?,
  id: json['id'] as String?,
  addedAt: json['addedAt'] == null
      ? null
      : DateTime.parse(json['addedAt'] as String),
  info: json['info'] == null
      ? null
      : WebInfo.fromJson(json['info'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WatchlistCategoryModelToJson(
  WatchlistCategoryModel instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.info?.toJson() case final value?) 'info': value,
  if (instance.name case final value?) 'name': value,
  if (instance.link case final value?) 'link': value,
  if (instance.addedAt?.toIso8601String() case final value?) 'addedAt': value,
};
