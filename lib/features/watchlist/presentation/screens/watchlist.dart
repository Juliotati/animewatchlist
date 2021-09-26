part of presentation;

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WatchListModel>>(
        future: LocalDatasourceImpl.instance.getAllAnimes(),
        builder: (BuildContext context,
            AsyncSnapshot<List<WatchListModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AnimeAlert('LOADING');
          }
          if (snapshot.hasError) {
            return const AnimeAlert('ERROR - COULD NOT LOAD WATCHLIST');
          }
          if (snapshot.data!.isEmpty || !snapshot.hasData) {
            return const AnimeAlert('WATCHLIST IS EMPTY');
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, int i) {
              return AnimeSeparator(
                index: i,
                watchlist: snapshot.data!,
              );
            },
            itemBuilder: (BuildContext context, int i) {
              final List<WatchListModel> data = snapshot.data!;
              return WatchlistCard(
                key: ValueKey<String>('$i-${data[i].folder}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data[i].links.map((String link) {
                    if (link.isEmpty) return const SizedBox.shrink();
                    return AnimeName(link);
                  }).toList(),
                ),
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}

enum Anime {
  id,
  name,
  link,
}
