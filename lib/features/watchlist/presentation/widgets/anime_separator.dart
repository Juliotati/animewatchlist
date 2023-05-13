part of '../presentation.dart';

class AnimeSeparator extends StatelessWidget {
  const AnimeSeparator({
    super.key,
    required this.folderType,
    required this.totalAnime,
  });

  final int totalAnime;
  final AnimeFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 8.0),
        child: Text(
          '${folderType.name} - $totalAnime'.toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: folderType.color,
              ),
        ),
      ),
    );
  }
}
