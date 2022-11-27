part of presentation;

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    super.key,
    required this.child,
    required this.folderType,
  });

  final Widget child;
  final AnimeFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: folderType.color.withOpacity(0.25),
      shadowColor: folderType.color,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: child,
      ),
    );
  }
}
