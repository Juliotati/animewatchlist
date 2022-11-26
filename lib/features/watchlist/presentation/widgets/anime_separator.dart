part of presentation;

class AnimeSeparator extends StatelessWidget {
  const AnimeSeparator({required this.folderType, required this.totalAnime});

  final int totalAnime;
  final AnimeFolderType folderType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Text(
        '${folderType.name} - $totalAnime'.toUpperCase(),
        style: Theme.of(context).textTheme.headline4!.copyWith(
              fontWeight: FontWeight.bold,
              color: folderType.color,
            ),
      ),
    );
  }
}
