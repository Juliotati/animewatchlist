part of '../presentation.dart';

class _AllAnime extends StatelessWidget {
  const _AllAnime(this.watchlist);

  final WatchlistModel watchlist;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverAppBar(
          collapsedHeight: 40,
          toolbarHeight: 40,
          expandedHeight: 40,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            SizedBox(
              height: 20,
              child: TextButton(
                onPressed: null,
                child: Text('Swipe for recommendations ->'),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.watching}>'),
          folderType: AnimeFolderType.watching,
          totalAnime: watchlist.watching.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.watching}>'),
          folderType: AnimeFolderType.watching,
          watchlist: watchlist.dropped,
        ),
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.planned}>'),
          folderType: AnimeFolderType.planned,
          totalAnime: watchlist.planned.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.planned}>'),
          folderType: AnimeFolderType.planned,
          watchlist: watchlist.dropped,
        ),
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.onHold}>'),
          folderType: AnimeFolderType.onHold,
          totalAnime: watchlist.onHold.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.onHold}>'),
          folderType: AnimeFolderType.onHold,
          watchlist: watchlist.dropped,
        ),
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.dropped}>'),
          folderType: AnimeFolderType.dropped,
          totalAnime: watchlist.dropped.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.dropped}>'),
          folderType: AnimeFolderType.dropped,
          watchlist: watchlist.dropped,
        ),
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.watched}>'),
          folderType: AnimeFolderType.watched,
          totalAnime: watchlist.watched.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.watched}>'),
          folderType: AnimeFolderType.watched,
          watchlist: watchlist.watched,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
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
              currentAnime.name.characters.first !=
                  watchlist[index - 1].name.characters.first;
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
