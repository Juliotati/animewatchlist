part of presentation;

class AnimeSeparator extends StatelessWidget {
  const AnimeSeparator({
    Key? key,
    required this.index,
    required this.watchlist,
  }) : super(key: key);

  final int index;

  final List<WatchListModel> watchlist;

  Color watchlistColor() {
    final String folder = watchlist[index + 1].folder;
    if (folder == AnimeFolder.watching) {
      return const Color.fromRGBO(62, 239, 109, 1.0);
    }
    if (folder == AnimeFolder.onhold) {
      return const Color.fromRGBO(239, 136, 62, 1.0);
    }
    if (folder == AnimeFolder.dropped) {
      return const Color.fromRGBO(239, 62, 62, 1.0);
    }
    if (folder == AnimeFolder.watched) {
      return const Color.fromRGBO(62, 106, 239, 1.0);
    }
    if (folder == AnimeFolder.planned) {
      return const Color.fromRGBO(255, 255, 255, 1.0);
    }
    return const Color.fromRGBO(255, 255, 255, 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final WatchListModel nextWatchlist = watchlist[index + 1];
    if (watchlist[index].folder != nextWatchlist.folder) {
      final String label = nextWatchlist.folder;
      final String totalInFolder = '${nextWatchlist.links.length}';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Text(
          '$label - $totalInFolder'.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.bold,
                color: watchlistColor(),
              ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
