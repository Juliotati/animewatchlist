part of '../presentation.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen();

  @override
  Widget build(BuildContext context) {
    return WatchlistBuilder(
      builder: (_, WatchlistModel watchlist, recommended) {
        return PageView.builder(
          itemCount: 2,
          controller: PageController(),
          itemBuilder: (context, index) {
            return [
              _AllAnime(watchlist),
              _RecommendedAnime(recommended),
            ][index];
          },
        );
      },
    );
  }
}

class WatchlistBuilder extends StatefulWidget {
  const WatchlistBuilder({required this.builder, super.key});

  final Widget Function(
    BuildContext,
    WatchlistModel,
    List<WatchlistCategoryModel>,
  ) builder;

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

              return widget.builder(
                context,
                WatchlistModel(
                  planned: sortByName(snapshot.data!.planned),
                  dropped: sortByName(snapshot.data!.dropped),
                  onHold: sortByName(snapshot.data!.onHold),
                  watched: sortByName(snapshot.data!.watched),
                  watching: sortByName(snapshot.data!.watching),
                ),
                snapshot.data!.recommended,
              );
            },
          ),
        ),
      ),
    );
  }
}
