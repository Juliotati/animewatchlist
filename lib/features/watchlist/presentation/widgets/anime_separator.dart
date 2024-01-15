part of '../presentation.dart';

class WatchListSeparator extends StatelessWidget {
  const WatchListSeparator({
    required this.folderType,
    required this.totalAnime,
    this.title,
    super.key,
  });

  final int totalAnime;
  final String? title;
  final AnimeFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 8.0),
        child: Text(
          (title ?? '${folderType.name} - $totalAnime').toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: folderType.color,
              ),
        ),
      ),
    );
  }
}
