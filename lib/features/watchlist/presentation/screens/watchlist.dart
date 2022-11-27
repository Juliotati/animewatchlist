part of presentation;

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen();

  @override
  Widget build(BuildContext context) {
    return WatchlistBuilder(
      builder: (_, WatchlistModel watchlistModel) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AnimeSeparator(
              folderType: AnimeFolderType.watching,
              totalAnime: watchlistModel.watching.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return AnimeName(
                    anime: watchlistModel.watching[index],
                    folderType: AnimeFolderType.watching,
                  );
                },
                childCount: watchlistModel.watching.length,
              ),
            ),
            AnimeSeparator(
              folderType: AnimeFolderType.planned,
              totalAnime: watchlistModel.planned.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return AnimeName(
                    anime: watchlistModel.planned[index],
                    folderType: AnimeFolderType.planned,
                  );
                },
                childCount: watchlistModel.planned.length,
              ),
            ),
            AnimeSeparator(
              folderType: AnimeFolderType.onHold,
              totalAnime: watchlistModel.onHold.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return AnimeName(
                    anime: watchlistModel.onHold[index],
                    folderType: AnimeFolderType.onHold,
                  );
                },
                childCount: watchlistModel.onHold.length,
              ),
            ),
            AnimeSeparator(
              folderType: AnimeFolderType.dropped,
              totalAnime: watchlistModel.dropped.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return AnimeName(
                    anime: watchlistModel.dropped[index],
                    folderType: AnimeFolderType.dropped,
                  );
                },
                childCount: watchlistModel.dropped.length,
              ),
            ),
            AnimeSeparator(
              folderType: AnimeFolderType.watched,
              totalAnime: watchlistModel.watched.length,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return AnimeName(
                    anime: watchlistModel.watched[index],
                    folderType: AnimeFolderType.watched,
                  );
                },
                childCount: watchlistModel.watched.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WatchlistBuilder extends StatefulWidget {
  const WatchlistBuilder({required this.builder, super.key});

  final Widget Function(BuildContext, WatchlistModel) builder;

  @override
  State<WatchlistBuilder> createState() => _WatchlistBuilderState();
}

class _WatchlistBuilderState extends State<WatchlistBuilder> {
  late Future<WatchlistModel> watchlistFuture;

  void _initializeAnimeList() {
    watchlistFuture = LocalDatasourceImpl.instance.animeWatchlist();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: FutureBuilder<WatchlistModel>(
            future: watchlistFuture,
            builder: (_, AsyncSnapshot<WatchlistModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AnimeAlert('LOADING');
              }
              if (snapshot.hasError) {
                return const AnimeAlert('ERROR - COULD NOT LOAD WATCHLIST');
              }
              if (!snapshot.hasData) {
                return const AnimeAlert('WATCHLIST IS EMPTY');
              }
              return widget.builder(context, snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

List<WatchlistCategoryModel>? sortByName(List<WatchlistCategoryModel>? data) {
  return data
    ?..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
    ..toList();
}
