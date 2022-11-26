// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistCategoryModel _$WatchlistCategoryModelFromJson(
        Map<String, dynamic> json) =>
    WatchlistCategoryModel(
      link: json['link'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$WatchlistCategoryModelToJson(
        WatchlistCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
    };
