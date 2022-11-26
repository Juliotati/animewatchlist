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
      elevation: 10.0,
      color: folderType.color.withOpacity(0.25),
      shadowColor: folderType.color,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
        child: child,
      ),
    );
  }
}
