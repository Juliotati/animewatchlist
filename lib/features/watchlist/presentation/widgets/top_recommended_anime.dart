part of '../../watchlist.dart';

class _TopRecommendedAnime extends StatelessWidget {
  const _TopRecommendedAnime({
    required this.topAnime,
    required this.recommended,
  });

  final List<WatchlistCategoryModel> topAnime;
  final List<WatchlistCategoryModel> recommended;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<WatchlistProvider>().reloadWatchlist,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          Top10AnimeList(topAnime: topAnime),
          const SectionLabel('View grouped folders 👉', 1),
          WatchExpansionTileGroup(
            startExpanded: true,
            key: Key('AnimeSeparator<${WatchlistFolderType.recommended}>'),
            folderType: WatchlistFolderType.recommended,
            totalAnime: recommended.length,
            watchlist: recommended,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

@immutable
class Top10AnimeList extends StatefulWidget {
  const Top10AnimeList({required this.topAnime, super.key});

  final List<WatchlistCategoryModel> topAnime;

  @override
  State<Top10AnimeList> createState() => _Top10AnimeListState();
}

class _Top10AnimeListState extends State<Top10AnimeList> {
  int visibleItemCount = 5;

  String get title {
    return switch (visibleItemCount) {
      5 => 'expand top 10',
      10 => 'expand top 15',
      15 => 'expand top 20',
      20 => 'expand top 30',
      _ => 'back to top 5',
    };
  }

  List<WatchlistCategoryModel> get topAnime {
    return widget.topAnime.take(visibleItemCount).toList();
  }

  void toggleVisibleItemCount() {
    visibleItemCount = switch (visibleItemCount) {
      5 => 10,
      10 => 15,
      15 => 20,
      20 => 30,
      _ => 5,
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.black87,
        elevation: 2,
        margin: const EdgeInsets.all(12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            WatchExpansionTileGroup(
              startExpanded: true,
              key: const Key('AnimeSeparator<TopAnime>'),
              folderType: WatchlistFolderType.recommended,
              title: 'RANKING | TOP $visibleItemCount 🔥',
              totalAnime: topAnime.length,
              watchlist: topAnime,
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: toggleVisibleItemCount,
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
