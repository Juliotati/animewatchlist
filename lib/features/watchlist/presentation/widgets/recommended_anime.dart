part of '../presentation.dart';

class _RecommendedAnime extends StatelessWidget {
  const _RecommendedAnime(this.commended);

  final List<WatchlistCategoryModel> commended;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.commended}>'),
          folderType: AnimeFolderType.commended,
          totalAnime: commended.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.commended}>'),
          folderType: AnimeFolderType.commended,
          watchlist: commended,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}
