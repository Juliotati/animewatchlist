part of '../presentation.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen();

  static final PageController _controllers = PageController();

  @override
  Widget build(BuildContext context) {
    return WatchlistBuilder(
      builder: (_, WatchlistModel watchlist, recommended) {
        return PageView.builder(
          itemCount: 2,
          controller: _controllers,
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
                  watching: sortByName(snapshot.data?.watching),
                  planned: sortByName(snapshot.data?.planned),
                  onHold: sortByName(snapshot.data?.onHold),
                  dropped: sortByName(snapshot.data?.dropped),
                  watched: sortByName(snapshot.data?.watched),
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
