part of presentation;

class AnimeName extends StatelessWidget {
  const AnimeName({
    required this.anime,
    required this.folderType,
    super.key,
  });

  final WatchlistCategoryModel anime;
  final AnimeFolderType folderType;

  Future<void> openAnimePage() async {
    try {
      final bool _canLaunch = await canLaunch(anime.link);
      if (_canLaunch) await launch(anime.link);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            Expanded(
              child: SelectableText(
                anime.name,
                maxLines: 3,
                scrollPhysics: const BouncingScrollPhysics(),
                style: headline6,
              ),
            )
          else
            Expanded(
              child: Text(
                anime.name,
                maxLines: 2,
                style: headline6?.copyWith(fontSize: 18.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          InkWell(
            onTap: openAnimePage,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.launch, color: folderType.color),
            ),
          ),
        ],
      ),
    );
  }
}
