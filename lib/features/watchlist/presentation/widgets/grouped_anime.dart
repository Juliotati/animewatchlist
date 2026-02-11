part of '../../watchlist.dart';

class _GroupedAnime extends StatelessWidget {
  const _GroupedAnime({required this.watchlist});

  final WatchlistModel watchlist;

  int get watching => watchlist.watching.length;

  int get planned => watchlist.planned.length;

  int get onHold => watchlist.onHold.length;

  int get dropped => watchlist.dropped.length;

  int get watched => watchlist.watched.length;

  String get totalAnime {
    return '${watching + planned + onHold + dropped + watched}';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<WatchlistProvider>().reloadWatchlist,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 30.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 8.0,
                children: [
                  AnimeStats('$watching', folder: WatchlistFolderType.watching),
                  AnimeStats('$planned', folder: WatchlistFolderType.planned),
                  AnimeStats('$onHold', folder: WatchlistFolderType.onHold),
                  AnimeStats('$dropped', folder: WatchlistFolderType.dropped),
                  AnimeStats('$watched', folder: WatchlistFolderType.watched),
                  AnimeStats(totalAnime, label: 'Total Anime'),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          const SectionLabel('👈 Top anime', 0),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          WatchExpansionTileGroup(
            key: Key('WatchlistSeparator<${WatchlistFolderType.watching}>'),
            folderType: WatchlistFolderType.watching,
            totalAnime: watching,
            watchlist: watchlist.watching,
          ),
          WatchExpansionTileGroup(
            key: Key('WatchlistSeparator<${WatchlistFolderType.planned}>'),
            folderType: WatchlistFolderType.planned,
            totalAnime: planned,
            watchlist: watchlist.planned,
          ),
          WatchExpansionTileGroup(
            key: Key('WatchlistSeparator<${WatchlistFolderType.onHold}>'),
            folderType: WatchlistFolderType.onHold,
            totalAnime: onHold,
            watchlist: watchlist.onHold,
          ),
          WatchExpansionTileGroup(
            key: Key('WatchlistSeparator<${WatchlistFolderType.dropped}>'),
            folderType: WatchlistFolderType.dropped,
            totalAnime: dropped,
            watchlist: watchlist.dropped,
          ),
          WatchExpansionTileGroup(
            key: Key('WatchlistSeparator<${WatchlistFolderType.watched}>'),
            folderType: WatchlistFolderType.watched,
            totalAnime: watched,
            watchlist: watchlist.watched,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class WatchExpansionTileGroup extends StatelessWidget {
  const WatchExpansionTileGroup({
    required this.folderType,
    required this.totalAnime,
    required this.watchlist,
    this.startExpanded = false,
    this.title,
    super.key,
  });

  final int totalAnime;
  final String? title;
  final bool startExpanded;
  final WatchlistFolderType folderType;
  final List<WatchlistCategoryModel> watchlist;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    );

    return SliverToBoxAdapter(
      child: ExpansionTile(
        shape: shape,
        initiallyExpanded: startExpanded,
        collapsedIconColor: folderType.color,
        collapsedShape: shape,
        title: Text(
          (title ?? '${folderType.name} - $totalAnime').toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: folderType.color,
          ),
        ),
        children: [
          AnimeCategoryList(
            key: Key('AnimeCategoryList<$folderType>'),
            folderType: folderType,
            watchlist: watchlist,
          ),
        ],
      ),
    );
  }
}

class AnimeCategoryList extends StatelessWidget {
  const AnimeCategoryList({
    super.key,
    required this.watchlist,
    required this.folderType,
    this.showInitial = true,
    this.showRank = false,
  });

  final WatchlistFolderType folderType;
  final List<WatchlistCategoryModel> watchlist;
  final bool showInitial;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).width > 600;

    if (isLargeScreen) {
      return Padding(
        padding: folderType.recommendedFolder && showRank
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : EdgeInsets.zero,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: showRank ? 300 : 400,
            mainAxisExtent: showRank ? 120 : 150,
          ),
          shrinkWrap: true,
          itemCount: watchlist.length,
          itemBuilder: (_, int index) {
            final currentAnime = watchlist[index];
            return _AnimeRanking(
              rank: index + 1,
              showRank: showRank,
              preview: AnimePreview(
                key: Key('Anime<${currentAnime.name}-$index>'),
                anime: currentAnime,
                folderType: folderType,
              ),
            );
          },
        ),
      );
    }

    return ListView.builder(
      itemCount: watchlist.length,
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 16.0),
      itemBuilder: (_, int index) {
        String validChar(Characters char) => char.isEmpty ? '' : char.first;

        final validIndex = (index - 1).clamp(0, index);

        final anime = watchlist[index];
        final hasDifferentInitial =
            validChar(anime.displayName.characters) !=
            validChar(watchlist[validIndex].displayName.characters);
        final shouldShowInitial = index == 0 || hasDifferentInitial;

        return _AnimeRanking(
          rank: index + 1,
          showRank: showRank,
          preview: AnimePreview(
            key: Key('Anime<${anime.name}-$index>'),
            showInitial: showInitial ? shouldShowInitial : showInitial,
            anime: anime,
            folderType: folderType,
          ),
        );
      },
    );
  }
}

@immutable
class _AnimeRanking extends StatelessWidget {
  const _AnimeRanking({
    required this.rank,
    required this.preview,
    this.showRank = false,
  });

  final int rank;
  final bool showRank;
  final AnimePreview preview;

  WatchlistCategoryModel get anime => preview.anime;

  Future<void> openAnimePage() async {
    try {
      if (anime.link == null) return;
      await launchUrl(Uri.parse(anime.link ?? ''));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showRank) return preview;

    final headline6 = Theme.of(context).textTheme.titleLarge;
    final image = anime.info?.image ?? '';
    final hasImage = image.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WatchlistCard(
        folderType: WatchlistFolderType.watched,
        noPadding: true,
        child: LinkTargetDetector(
          target: anime.link,
          child: InkWell(
            splashColor: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            onTap: openAnimePage,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (hasImage)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                    child: Image.network(image, fit: BoxFit.cover, height: 110),
                  ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 10.0),
                          child: Text(
                            anime.name ?? anime.info?.title ?? '???',
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: headline6?.copyWith(
                              fontSize: 18.0,
                              color: WatchlistFolderType.watched.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            '#$rank',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimeStats extends StatelessWidget {
  const AnimeStats(this.data, {this.folder, this.label});

  final String data;
  final String? label;
  final WatchlistFolderType? folder;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Text(
          '${folder?.name ?? label}: $data',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: folder?.color,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.data, this.screen);

  final String data;
  final int screen;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Align(
        alignment: Alignment.centerLeft,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () => context.read<WatchlistProvider>().goToPage(screen),
              child: Card(
                color: Colors.black87,
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    data,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
