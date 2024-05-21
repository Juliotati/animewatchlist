part of '../../watchlist.dart';

enum WatchlistFolderType {
  planned('Planned', Color.fromRGBO(255, 255, 255, 1.0)),
  dropped('Dropped', Color.fromRGBO(239, 62, 62, 1.0)),
  onHold('On-Hold', Color.fromRGBO(239, 136, 62, 1.0)),
  recommended('Recommended', Color.fromRGBO(71, 125, 255, 1.0)),
  watched('Watched', Color.fromRGBO(71, 125, 255, 1.0)),
  watching('Watching', Color.fromRGBO(62, 239, 109, 1.0));

  const WatchlistFolderType(this.name, this.color);

  bool get recommendedFolder => this == recommended;

  bool get watchedFolder => this == watched;

  final String name;
  final Color color;
}
