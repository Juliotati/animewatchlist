part of '../presentation.dart';

class AnimeName extends StatelessWidget {
  const AnimeName({
    required this.anime,
    required this.folderType,
    this.showInitial = false,
    super.key,
  });

  final bool showInitial;
  final WatchlistCategoryModel anime;
  final AnimeFolderType folderType;

  Future<void> openAnimePage() async {
    try {
      await launchUrl(Uri.parse(anime.link));
    } catch (_) {
      rethrow;
    }
  }

  String get animeName {
    if (anime.isRecommended) return '🔥 ${anime.name}';
    return anime.name;
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.titleLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showInitial)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: Text(
              anime.name.characters.first.toUpperCase(),
              style: headline6?.copyWith(
                color: folderType.color.withOpacity(0.5),
              ),
            ),
          ),
        WatchlistCard(
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
                    style: headline6?.copyWith(fontSize: 16.0),
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
        ),
      ],
    );
  }
}
