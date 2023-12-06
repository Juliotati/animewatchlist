part of '../presentation.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Consumer<AnimeProvider>(
            builder: (_, provider, __) {
              if (provider.state.isLoading) {
                return const AnimeAlert('LOADING...');
              }

              if (provider.state.hasError) {
                return const AnimeAlert('ERROR - COULD NOT LOAD WATCHLIST');
              }

              if (provider.state.notData) {
                return const AnimeAlert('WATCHLIST IS EMPTY');
              }

              final watchlist = provider.watchlist;
              final recommendedWatchlist = watchlist.recommended ?? [];

              return Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: 2,
                    controller: context.read<AnimeProvider>().controller,
                    itemBuilder: (context, index) {
                      return [
                        _GroupedAnime(watchlist),
                        _RecommendedAnime(recommendedWatchlist),
                      ][index];
                    },
                  ),
                  const Positioned(
                    left: 30,
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
    context.read<AnimeProvider>().filterWatchlist('');
    _SearchAnimeField._controller.clear();
    _SearchAnimeField._focusNode.unfocus();
  }

  @override
  void initState() {
    _SearchAnimeField._focusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.black;
    final reloading = context.select((AnimeProvider p) => p.state.isReloading);
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: 45,
        width: hasFocus
            ? 300
            : reloading
                ? 120
                : 105,
        child: TextFormField(
          controller: _SearchAnimeField._controller,
          focusNode: _SearchAnimeField._focusNode,
          decoration: InputDecoration(
            filled: true,
            hintText: reloading ? 'reloading...' : 'search...',
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            fillColor: hasFocus ? color : color.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: hasFocus
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 24),
                    onPressed: () => _clear(context),
                  )
                : null,
          ),
          onChanged: context.read<AnimeProvider>().filterWatchlist,
        ),
      ),
    );
  }
}
