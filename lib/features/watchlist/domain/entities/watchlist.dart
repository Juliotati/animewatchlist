import 'package:equatable/equatable.dart';

class WatchList extends Equatable {
  const WatchList({
    required this.folder,
    required this.links,
  });

  final String folder;
  final List<String> links;

  @override
  List<dynamic> get props => <dynamic>[
        folder,
        links,
      ];
}
