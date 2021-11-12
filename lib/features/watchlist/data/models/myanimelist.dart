import 'package:animewatchlist/features/watchlist/domain/entities/myanimelist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'myanimelist.g.dart';

@JsonSerializable(explicitToJson: true)
class MyanimelistModel extends Myanimelist {
  const MyanimelistModel({
    required this.data,
    required this.paging,
  }) : super(data: data, paging: paging);

  factory MyanimelistModel.fromJson(Map<String, dynamic> json) {
    return _$MyanimelistModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MyanimelistModelToJson(this);
  }

  final List<DataModel> data;
  final PagingModel paging;
}

@JsonSerializable()
class DataModel extends Data {
  const DataModel(this.node) : super(node);

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return _$DataModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataModelToJson(this);
  }

  final NodeModel node;
}

@JsonSerializable(explicitToJson: true)
class NodeModel extends Node {
  const NodeModel({
    required this.id,
    required this.title,
    required this.mainPicture,
  }) : super(id: id, title: title, mainPicture: mainPicture);

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return _$NodeModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NodeModelToJson(this);
  }

  final int id;
  final String title;
  final MainPictureModel mainPicture;
}

@JsonSerializable()
class MainPictureModel extends MainPicture {
  const MainPictureModel({
    required this.medium,
    required this.large,
  }) : super(medium: medium, large: large);

  factory MainPictureModel.fromJson(Map<String, dynamic> json) {
    return _$MainPictureModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MainPictureModelToJson(this);
  }

  @override
  final String medium;
  final String large;
}

@JsonSerializable()
class PagingModel extends Paging {
  const PagingModel(this.next) : super(next);

  factory PagingModel.fromJson(Map<String, dynamic> json) {
    return _$PagingModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PagingModelToJson(this);
  }

  final String next;
}
