part of presentation;

enum AnimeFolderType {
  planned('Planned', Color.fromRGBO(255, 255, 255, 1.0)),
  dropped('dropped', Color.fromRGBO(239, 62, 62, 1.0)),
  onhold('On-Hold', Color.fromRGBO(239, 136, 62, 1.0)),
  watched('Watched', Color.fromRGBO(62, 106, 239, 1.0)),
  watching('Watching', Color.fromRGBO(62, 239, 109, 1.0));

  const AnimeFolderType(this.name, this.color);

  final String name;
  final Color color;
}
