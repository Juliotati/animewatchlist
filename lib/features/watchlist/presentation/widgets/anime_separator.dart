part of presentation;

class AnimeSeparator extends StatelessWidget {
  const AnimeSeparator({
    Key? key,
    required this.index,
    required this.watchlist,
  }) : super(key: key);

  final int index;

  final List<WatchListModel> watchlist;

  @override
  Widget build(BuildContext context) {
    final WatchListModel nextWatchlist = watchlist[index + 1];
    if (watchlist[index].folder != nextWatchlist.folder) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Text(
          '${nextWatchlist.folder.toUpperCase()} - ${nextWatchlist.links.length}',
          style: Theme.of(context).textTheme.headline4!.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(255, 255, 255, 0.2)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
