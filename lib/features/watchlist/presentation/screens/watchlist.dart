part of presentation;

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WatchlistModel>(
        future: LocalDatasourceImpl.instance.animeWatchlist(),
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

          final List<dynamic> allAnime = [
            AnimeFolderType.watching,
            sortByName(snapshot.data?.watching),
            AnimeFolderType.planned,
            sortByName(snapshot.data?.planned),
            AnimeFolderType.onhold,
            sortByName(snapshot.data?.onHold),
            AnimeFolderType.dropped,
            sortByName(snapshot.data?.dropped),
            AnimeFolderType.watched,
            sortByName(snapshot.data?.watched),
          ];

          return ListView.builder(
            padding: const EdgeInsets.only(top: 30, bottom: 60.0),
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

List<WatchlistCategoryModel>? sortByName(List<WatchlistCategoryModel>? data) {
  return data
    ?..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()))
    ..toList();
}
