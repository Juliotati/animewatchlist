part of '../presentation.dart';

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
      onRefresh: context.read<AnimeProvider>().reloadWatchlist,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          Top10AnimeList(topAnime: topAnime),
          WatchListSeparator(
            key: Key('AnimeSeparator<${AnimeFolderType.recommended}>'),
            folderType: AnimeFolderType.recommended,
            totalAnime: recommended.length,
          ),
          AnimeCategoryList(
            key: Key('AnimeCategoryList<${AnimeFolderType.recommended}>'),
            folderType: AnimeFolderType.recommended,
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

  String get title => visibleItemCount == 5 ? 'expand to top 10' : 'back to top 5';

  List<WatchlistCategoryModel> get topAnime => widget.topAnime.take(visibleItemCount).toList();

  void toggleVisibleItemCount() {
    setState(() => visibleItemCount = visibleItemCount == 5 ? 10 : 5);
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
            WatchListSeparator(
              key: const Key('AnimeSeparator<TopAnime>'),
              folderType: AnimeFolderType.recommended,
              title: 'TOP 10 🔥',
              totalAnime: topAnime.length,
            ),
            AnimeCategoryList(
              key: const Key('AnimeCategoryList<TopAnime>'),
              folderType: AnimeFolderType.recommended,
              watchlist: topAnime,
              showInitial: false,
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: toggleVisibleItemCount,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
