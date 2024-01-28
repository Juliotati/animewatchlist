part of '../presentation.dart';

class _GroupedAnime extends StatelessWidget {
  const _GroupedAnime({required this.watchlist});

  final WatchlistModel watchlist;

  int get watchingTotal => watchlist.watching.length;

  int get plannedTotal => watchlist.planned.length;

  int get onHoldTotal => watchlist.onHold.length;

  int get droppedTotal => watchlist.dropped.length;

  int get watchedTotal => watchlist.watched.length;

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
              padding: const EdgeInsets.only(left: 16.0, top: 30.0),
              child: Wrap(
                spacing: 6.0,
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
                  AnimeStats(totalAnime, label: 'Total Anime'),
                ],
              ),
            ),
          ),
          const SectionLabel('👈 Top anime', 0),
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
    this.showInitial = true,
  });

  final AnimeFolderType folderType;
  final List<WatchlistCategoryModel> watchlist;
  final bool showInitial;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).width > 600;

    if (isLargeScreen) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 400 / 212,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            final currentAnime = watchlist[index];
            return AnimePreview(
              key: Key('Anime<${currentAnime.name}-$index>'),
              anime: currentAnime,
              folderType: folderType,
            );
          },
          childCount: watchlist.length,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {
          String validChar(Characters char) => char.isEmpty ? '' : char.first;

          final validIndex = (index - 1).clamp(0, index);

          final anime = watchlist[index];
          final hasDifferentInitial = validChar(anime.displayName.characters) !=
              validChar(watchlist[validIndex].displayName.characters);
          final shouldShowInitial = index == 0 || hasDifferentInitial;

          return AnimePreview(
            key: Key('Anime<${anime.name}-$index>'),
            showInitial: showInitial ? shouldShowInitial : showInitial,
            anime: anime,
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
    return Card(
      color: Colors.black87,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          '${folder?.name ?? label}: $data',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: folder?.color,
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
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 10.0,
              bottom: 8.0,
            ),
            child: GestureDetector(
              onTap: () => context.read<AnimeProvider>().goToPage(screen),
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
