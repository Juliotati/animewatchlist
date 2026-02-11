part of '../core.dart';

Future<void> foldersOptionsSheet(
  BuildContext context,
  WatchlistFolderType current,
  WatchlistCategoryModel anime,
) async {
  if (kIsWeb || anime.isRecommended || current.recommendedFolder) return;

  showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Move from "${current.name}" to:',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ...WatchlistFolderType.values
              .where((folder) {
                return folder != current && !folder.recommendedFolder;
              })
              .toList()
              .map((folder) {
                return ListTile(
                  title: Text(
                    folder.name,
                    style: TextStyle(color: folder.color),
                  ),
                  trailing: Icon(
                    Icons.keyboard_double_arrow_right,
                    color: folder.color,
                    size: 18,
                  ),
                  onTap: () {
                    final provider = context.read<WatchlistProvider>();
                    provider.moveAnime(from: current, to: folder, anime: anime);
                    provider.reloadWatchlist();
                    Navigator.pop(sheetContext);
                  },
                );
              }),
          const SizedBox(height: 20),
        ],
      );
    },
  );
}
