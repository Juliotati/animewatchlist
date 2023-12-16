part of '../presentation.dart';

class _GroupedAnime extends StatelessWidget {
  const _GroupedAnime(this.watchlist);

  final WatchlistModel watchlist;

  int get watchingTotal => watchlist.watching.length;

  int get plannedTotal => watchlist.planned.length;

  int get onHoldTotal => watchlist.onHold.length;

  int get droppedTotal => watchlist.dropped.length;

  int get watchedTotal => watchlist.watched.length;

  int get recommendedTotal => watchlist.recommendedFromAll.length;

  String get totalAnime {
    return '${watchingTotal + plannedTotal + onHoldTotal + droppedTotal + watchedTotal}';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<AnimeProvider>().reloadWatchlist,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: AnimeStats(label: 'Recommended', '$recommendedTotal 👉'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Wrap(
                runAlignment: WrapAlignment.end,
                alignment: WrapAlignment.end,
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  AnimeStats(
                    '$watchingTotal',
                    folder: AnimeFolderType.watching,
                  ),
                  AnimeStats('$plannedTotal', folder: AnimeFolderType.planned),
                  AnimeStats('$onHoldTotal', folder: AnimeFolderType.onHold),
                  AnimeStats('$droppedTotal', folder: AnimeFolderType.dropped),
                  AnimeStats('$watchedTotal', folder: AnimeFolderType.watched),
                  AnimeStats(label: 'Total Anime:', ' $totalAnime'),
                ],
              ),
            ),
          ),
          WatchListSeparator(
            key: Key('WatchlistSeparator<${AnimeFolderType.watching}>'),
            folderType: AnimeFolderType.watching,
            totalAnime: watchingTotal,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.watching}>'),
            folderType: AnimeFolderType.watching,
            watchlist: watchlist.watching,
          ),
          WatchListSeparator(
            key: Key('WatchlistSeparator<${AnimeFolderType.planned}>'),
            folderType: AnimeFolderType.planned,
            totalAnime: plannedTotal,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.planned}>'),
            folderType: AnimeFolderType.planned,
            watchlist: watchlist.planned,
          ),
          WatchListSeparator(
            key: Key('WatchlistSeparator<${AnimeFolderType.onHold}>'),
            folderType: AnimeFolderType.onHold,
            totalAnime: onHoldTotal,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.onHold}>'),
            folderType: AnimeFolderType.onHold,
            watchlist: watchlist.onHold,
          ),
          WatchListSeparator(
            key: Key('WatchlistSeparator<${AnimeFolderType.dropped}>'),
            folderType: AnimeFolderType.dropped,
            totalAnime: droppedTotal,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.dropped}>'),
            folderType: AnimeFolderType.dropped,
            watchlist: watchlist.dropped,
          ),
          WatchListSeparator(
            key: Key('WatchlistSeparator<${AnimeFolderType.watched}>'),
            folderType: AnimeFolderType.watched,
            totalAnime: watchedTotal,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.watched}>'),
            folderType: AnimeFolderType.watched,
            watchlist: watchlist.watched,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
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
  });

  final AnimeFolderType folderType;
  final List<WatchlistCategoryModel> watchlist;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {
          final currentAnime = watchlist[index];
          final showInitial = index == 0 ||
              currentAnime.name?.characters.first !=
                  watchlist[index - 1].name?.characters.first;
          return AnimePreview(
            key: Key('Anime<${currentAnime.name}-$index>'),
            showInitial: showInitial,
            anime: currentAnime,
            folderType: folderType,
          );
        },
        childCount: watchlist.length,
      ),
    );
  }
}

class AnimeStats extends StatelessWidget {
  const AnimeStats(this.data, {this.folder, this.label});

  final String data;
  final String? label;
  final AnimeFolderType? folder;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${folder?.name ?? label}: $data',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 12,
        color: folder?.color,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
