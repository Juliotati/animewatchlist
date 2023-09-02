part of '../presentation.dart';

class AnimePreview extends StatefulWidget {
  const AnimePreview({
    required this.anime,
    required this.folderType,
    this.showInitial = false,
    super.key,
  });

  final bool showInitial;
  final WatchlistCategoryModel anime;
  final AnimeFolderType folderType;

  @override
  State<AnimePreview> createState() => _AnimePreviewState();
}

class _AnimePreviewState extends State<AnimePreview> {
  static String errorTitle = 'Ops could\'t get a title';
  static String errorDescription =
      'DANG!! Could\'t load the description new, but i\'m sure it\'s a BANGER!! \nTap on the page to find out.';
  static String errorImage =
      'https://fonts.gstatic.com/s/e/notoemoji/latest/1f972/512.webp';

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.titleLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showInitial)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: Text(
              widget.anime.name.characters.first.toUpperCase(),
              style: headline6?.copyWith(
                color: widget.folderType.color.withOpacity(0.5),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: LinkPreviewGenerator(
              key: ValueKey(widget.anime.link),
              bodyMaxLines: 4,
              link: widget.anime.link,
              cacheDuration: const Duration(days: 90),
              linkPreviewStyle: LinkPreviewStyle.small,
              borderRadius: 8.0,
              showDomain: false,
              removeElevation: true,
              description: (desc) {
                final starterInfoIndex = desc.indexOf('. ') + 2;
                return desc.substring(starterInfoIndex);
              },
              titleStyle: TextStyle(
                fontSize: 18,
                color: widget.folderType.color,
              ),
              boxShadow: const [],
              backgroundColor: widget.folderType.color.withOpacity(0.05),
              errorBody: errorDescription,
              errorTitle: errorTitle,
              errorImage: errorImage,
              errorWidget: AnimePreviewPlaceholder(
                anime: widget.anime,
                folderType: widget.folderType,
              ),
              placeholderWidget: AnimePreviewPlaceholder(
                anime: widget.anime,
                folderType: widget.folderType,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimePreviewPlaceholder extends StatelessWidget {
  const AnimePreviewPlaceholder({
    super.key,
    required this.anime,
    required this.folderType,
  });

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
    return WatchlistCard(
      folderType: folderType,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
    );
  }
}
