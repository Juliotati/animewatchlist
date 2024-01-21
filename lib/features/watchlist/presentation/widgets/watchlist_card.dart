part of '../presentation.dart';

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    required this.child,
    required this.folderType,
    super.key,
  });

  final Widget child;
  final AnimeFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: folderType.color.withOpacity(0.25),
      shadowColor: folderType.color,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: child,
      ),
    );
  }
}
