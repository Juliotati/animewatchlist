part of presentation;

class AnimeName extends StatelessWidget {
  const AnimeName(this.data, {Key? key}) : super(key: key);
  final String data;

  Future<void> openAnimePage() async {
    try {
      canLaunch(data);
      await launch(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          Expanded(
            child: SelectableText(
              animeData(data: data, anime: Anime.name),
              maxLines: 1,
              scrollPhysics: const BouncingScrollPhysics(),
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        else
          Expanded(
            child: Text(
              animeData(data: data, anime: Anime.name),
              maxLines: 1,
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.fade,
            ),
          ),
        InkWell(
          onTap: openAnimePage,
          borderRadius: BorderRadius.circular(8.0),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.launch),
          ),
        )
      ],
    );
  }
}

String animeData({required String data, required Anime anime}) {
  final List<String> _data = data
      .replaceFirst('http://myanimelist.net/anime/', '')
      .replaceAll('_', ' ')
      .split('/');

  if (anime == Anime.id) return _data.first;

  if (anime == Anime.name) return _data.last;

  return data;
}
