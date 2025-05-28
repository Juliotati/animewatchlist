part of '../../watchlist.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Consumer<WatchlistProvider>(
            builder: (_, provider, __) {
              if (provider.state.isLoading) {
                return const AnimeAlert(state: WatchlistState.loading);
              }

              if (provider.state.hasError) {
                return const AnimeAlert(state: WatchlistState.error);
              }

              if (provider.state.notData) {
                return const AnimeAlert(state: WatchlistState.empty);
              }

              final watchlist = provider.watchlist;
              final recommendedWatchlist = watchlist.recommended ?? [];

              return Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  PageView.builder(
                    itemCount: 2,
                    controller: context.read<WatchlistProvider>().controller,
                    itemBuilder: (context, index) {
                      return [
                        _TopRecommendedAnime(
                          topAnime: watchlist.topAnime,
                          recommended: recommendedWatchlist,
                        ),
                        _GroupedAnime(watchlist: watchlist),
                      ][index];
                    },
                  ),
                  const Positioned(
                    right: 30,
                    bottom: 20,
                    child: _SearchAnimeField(key: Key('SearchAnimeField')),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchAnimeField extends StatefulWidget {
  const _SearchAnimeField({super.key});

  static final FocusNode _focusNode = FocusNode();
  static final TextEditingController _controller = TextEditingController();

  @override
  State<_SearchAnimeField> createState() => _SearchAnimeFieldState();
}

class _SearchAnimeFieldState extends State<_SearchAnimeField> {
  bool get hasFocus => _SearchAnimeField._focusNode.hasFocus;

  void _clear(BuildContext context) {
    context.read<WatchlistProvider>().filterWatchlist('');
    _SearchAnimeField._controller.clear();
    Future.delayed(const Duration(milliseconds: 350), () {
      _SearchAnimeField._focusNode.unfocus();
    });
  }

  @override
  void didChangeDependencies() {
    _SearchAnimeField._focusNode.addListener(() => setState(() {}));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.black;
    final reloading = context.select(
      (WatchlistProvider p) => p.state.isReloading,
    );
    final totalWidth = MediaQuery.sizeOf(context).width;
    final inputWidth = hasFocus
        ? totalWidth * (totalWidth > 450 ? 0.4 : 0.8)
        : reloading
        ? 150.0
        : 130.0;
    return AnimatedSize(
      clipBehavior: Clip.none,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: 50,
        width: inputWidth,
        child: TextFormField(
          controller: _SearchAnimeField._controller,
          focusNode: _SearchAnimeField._focusNode,
          decoration: InputDecoration(
            filled: true,
            hintText: reloading
                ? 'reloading...'
                : hasFocus
                ? 'search anime name'
                : 'search an...',
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            fillColor: hasFocus ? color : color.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: hasFocus
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: const Icon(Icons.clear, size: 24),
                      onPressed: () => _clear(context),
                    ),
                  )
                : null,
          ),
          onChanged: context.read<WatchlistProvider>().filterWatchlist,
        ),
      ),
    );
  }
}
