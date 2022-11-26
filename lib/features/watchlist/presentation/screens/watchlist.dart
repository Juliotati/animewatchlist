part of presentation;

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WatchlistModel>(
        future: LocalDatasourceImpl.instance.animeWatchlist(),
        builder:
            (BuildContext context, AsyncSnapshot<WatchlistModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AnimeAlert('LOADING');
          }
          if (snapshot.hasError) {
            return const AnimeAlert('ERROR - COULD NOT LOAD WATCHLIST');
          }
          if (!snapshot.hasData) return const AnimeAlert('WATCHLIST IS EMPTY');

          final List<dynamic> allAnime = [
            AnimeFolderType.onhold,
            snapshot.data?.onHold,
            AnimeFolderType.watching,
            snapshot.data?.watching,
            AnimeFolderType.dropped,
            snapshot.data?.dropped,
            AnimeFolderType.planned,
            snapshot.data?.planned,
            AnimeFolderType.watched,
            snapshot.data?.watched,
          ];

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allAnime.length,
            itemBuilder: (BuildContext context, int index) {
              if (allAnime[index] is AnimeFolderType) {
                final total = (allAnime[index + 1] as List).length;
                return AnimeSeparator(
                  folderType: allAnime[index] as AnimeFolderType,
                  totalAnime: total,
                );
              }
              final currentAnimeList =
                  allAnime[index] as List<WatchlistCategoryModel>;
              final folderType = allAnime[index - 1] as AnimeFolderType;
              return WatchlistCard(
                folderType: folderType,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: currentAnimeList.map((anime) {
                    return AnimeName(
                      anime: anime,
                      folderType: folderType,
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
