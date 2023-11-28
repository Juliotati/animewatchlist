part of '../presentation.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with AutomaticKeepAliveClientMixin {
  static final PageController _controllers = PageController();

  late Future<WatchlistModel> watchlistFuture;

  bool _reloading = false;

  Future<void> _getAnimeWatchList({bool updateUI = true}) async {
    watchlistFuture = RemoteDatasourceImpl().animeWatchlist();
    if (updateUI) {
      log('refreshing watchlist info');
      _reloading = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getAnimeWatchList(updateUI: false);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: FutureBuilder<WatchlistModel>(
            future: watchlistFuture,
            builder: (_, AsyncSnapshot<WatchlistModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !_reloading) {
                return const AnimeAlert('LOADING...');
              }

              if (snapshot.hasError) {
                log('${snapshot.error}');
                return const AnimeAlert('ERROR - COULD NOT LOAD WATCHLIST');
              }

              if (!snapshot.hasData) {
                return const AnimeAlert('WATCHLIST IS EMPTY');
              }

              final watchlist = snapshot.data!;
              final recommendedWatchlist = watchlist.recommended;

              return PageView.builder(
                itemCount: 2,
                controller: _controllers,
                itemBuilder: (context, index) {
                  return [
                    _AllAnime(watchlist, _getAnimeWatchList),
                    _RecommendedAnime(recommendedWatchlist),
                  ][index];
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
