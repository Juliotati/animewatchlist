// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyanimelistModel _$MyanimelistModelFromJson(Map<String, dynamic> json) {
  return MyanimelistModel(
    data: (json['data'] as List<dynamic>)
        .map((e) => DataModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    paging: PagingModel.fromJson(json['paging'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MyanimelistModelToJson(MyanimelistModel instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'paging': instance.paging.toJson(),
    };

DataModel _$DataModelFromJson(Map<String, dynamic> json) {
  return DataModel(
    NodeModel.fromJson(json['node'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'node': instance.node,
    };

NodeModel _$NodeModelFromJson(Map<String, dynamic> json) {
  return NodeModel(
    id: json['id'] as int,
    title: json['title'] as String,
    mainPicture:
        MainPictureModel.fromJson(json['mainPicture'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NodeModelToJson(NodeModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'mainPicture': instance.mainPicture.toJson(),
    };

MainPictureModel _$MainPictureModelFromJson(Map<String, dynamic> json) {
  return MainPictureModel(
    medium: json['medium'] as String,
    large: json['large'] as String,
  );
}

Map<String, dynamic> _$MainPictureModelToJson(MainPictureModel instance) =>
    <String, dynamic>{
      'medium': instance.medium,
      'large': instance.large,
    };

PagingModel _$PagingModelFromJson(Map<String, dynamic> json) {
  return PagingModel(
    json['next'] as String,
  );
}

Map<String, dynamic> _$PagingModelToJson(PagingModel instance) =>
    <String, dynamic>{
      'next': instance.next,
    };
