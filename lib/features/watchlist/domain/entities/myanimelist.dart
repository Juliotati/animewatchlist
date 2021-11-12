import 'package:equatable/equatable.dart';

class Myanimelist extends Equatable {
  const Myanimelist({
    required this.data,
    required this.paging,
  });

  final List<Data> data;
  final Paging paging;

  @override
  List<Object?> get props => <Object>[data, paging];
}

class Data extends Equatable {
  const Data(this.node);

  final Node node;

  @override
  List<Object?> get props => <Node>[node];
}

class Node extends Equatable {
  const Node({
    required this.id,
    required this.title,
    required this.mainPicture,
  });

  final int id;
  final String title;
  final MainPicture mainPicture;

  @override
  List<Object?> get props => <Object>[id, title, mainPicture];
}

class MainPicture extends Equatable {
  const MainPicture({
    required this.medium,
    required this.large,
  });

  final String medium;
  final String large;

  @override
  List<Object?> get props => <Object>[medium, large];
}

class Paging extends Equatable {
  const Paging(this.next);

  final String next;

  @override
  List<Object?> get props => <String>[next];
}
