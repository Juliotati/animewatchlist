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

  String get animeName {
    if (hasTopAnime) return '🔥${anime.name}';
    return anime.name;
  }

  bool get hasTopAnime {
    return (has('naruto') && !has('boruto')) ||
        has('bleach') ||
        has('aot') ||
        has('quintessential') ||
        has('shield hero') ||
        has('dororo') ||
        has('to your eternity') ||
        has('weathering with you') ||
        has('your name') ||
        has('tower of god') ||
        has('golden boy') ||
        has('golden kamuy') ||
        has('i am what i am') ||
        has('certain scientific') ||
        has('blaze of the immortal') ||
        has('jormungand') ||
        has('baki') ||
        has('berserk') ||
        has('black lagoon') ||
        has('ajin') ||
        has('attack on titan') ||
        has('arcane') ||
        has('days') ||
        has('relife') ||
        has('one piece') ||
        has('death note') ||
        has('chainsaw man') ||
        (has('kingdom') && !has('hero')) ||
        has('cyberpunk') ||
        has('rent-a-girlfriend') ||
        has('overlord') ||
        has('gleipnir') ||
        has('jujutsu kaisen');
  }

  bool has(String value) {
    return anime.name.toLowerCase().contains(value.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return WatchlistCard(
      folderType: folderType,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            Expanded(
              child: SelectableText(
                animeName,
                maxLines: 3,
                scrollPhysics: const BouncingScrollPhysics(),
                style: headline6,
              ),
            )
          else
            Expanded(
              child: Text(
                animeName,
                maxLines: 2,
                style: headline6?.copyWith(fontSize: 18.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          InkWell(
            onTap: openAnimePage,
            splashColor: const Color.fromRGBO(0, 0, 0, 0.0),
            highlightColor: folderType.color.withOpacity(0.15),
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
