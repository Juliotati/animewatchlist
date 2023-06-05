part of '../presentation.dart';

class _RecommendedAnime extends StatelessWidget {
  const _RecommendedAnime(this.recommended);

  final List<WatchlistCategoryModel> recommended;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        AnimeSeparator(
          key: Key('AnimeSeparator<${AnimeFolderType.recommended}>'),
          folderType: AnimeFolderType.recommended,
          totalAnime: recommended.length,
        ),
        AnimeCategoryList(
          key: Key('AnimeCategoryList<${AnimeFolderType.recommended}>'),
          folderType: AnimeFolderType.recommended,
          watchlist: recommended,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}
