part of '../../watchlist.dart';

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    required this.child,
    required this.folderType,
    this.noPadding = false,
    super.key,
  });

  final Widget child;
  final bool noPadding;
  final WatchlistFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: folderType.color.withOpacity(0.1),
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: noPadding
          ? child
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: child,
            ),
    );
  }
}
