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

class _AnimePreviewState extends State<AnimePreview>
    with AutomaticKeepAliveClientMixin {
  static String errorTitle = 'Ops could\'t get a title';
  static String errorDescription = 'DANG!! Could\'t load this anime\'s '
      'description, but I\'m pretty sure it\'s a BANGER!! \nTAP ME for more.';
  static String errorImage = 'https://fonts.gstatic.com/s/e/notoemoji/latest/1f'
      '972/512.webp';

  WebInfo? _info;

  bool _loading = true;

  WatchlistCategoryModel get anime => widget.anime;

  WebInfo? get info => anime.info ?? _info;

  AnimeFolderType get folder => widget.folderType;

  void _onInfoLoaded(WebInfo? info) {
    if (info?.title == errorTitle) {
      log('No data for: ${info?.title}');
      return;
    }

    _info = info;
    _loading = false;
    if (mounted) setState(() {});

    log('Updating: ${info?.title}');
    const RemoteDatasourceImpl().updateAnimeInfo(folder, anime.id, info);
  }

  @override
  void initState() {
    _loading = info == null;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log('has info: ${anime.info != null} | ${anime.info?.title}');

    final headline6 = Theme.of(context).textTheme.titleLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showInitial)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: Text(
              anime.displayName?.characters.first.toUpperCase() ?? '',
              style: headline6?.copyWith(color: folder.color.withOpacity(0.5)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: LinkPreviewGenerator(
              key: ValueKey(anime.link),
              info: info,
              bodyMaxLines: 4,
              link: anime.link ?? '',
              cacheDuration: const Duration(days: 90),
              linkPreviewStyle: LinkPreviewStyle.small,
              borderRadius: 8.0,
              showDomain: false,
              removeShadow: true,
              description: (desc) {
                final starterInfoIndex = desc.indexOf('. ') + 2;
                return desc.substring(starterInfoIndex);
              },
              titleStyle: TextStyle(
                fontSize: 18,
                color: folder.color,
              ),
              boxShadow: const [],
              backgroundColor: folder.color.withOpacity(0.05),
              errorBody: errorDescription,
              errorTitle: errorTitle,
              errorImage: errorImage,
              errorWidget: AnimePreviewPlaceholder(
                anime: anime,
                folderType: folder,
              ),
              placeholderWidget: AnimePreviewPlaceholder(
                anime: anime,
                loading: _loading,
                folderType: folder,
              ),
              onInfoLoaded: _onInfoLoaded,
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
    this.loading = false,
  });

  final bool loading;
  final WatchlistCategoryModel anime;
  final AnimeFolderType folderType;

  Future<void> openAnimePage() async {
    try {
      if (anime.link == null) return;
      await launchUrl(Uri.parse(anime.link ?? ''));
    } catch (_) {
      rethrow;
    }
  }

  String get animeName {
    if (anime.isRecommended) return '🔥 ${anime.displayName}';
    return anime.displayName ?? '';
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
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Icon(Icons.launch, color: folderType.color),
            ),
          ),
        ],
      ),
    );
  }
}
