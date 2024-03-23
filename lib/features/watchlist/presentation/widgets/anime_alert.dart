part of '../presentation.dart';

class AnimeAlert extends StatelessWidget {
  const AnimeAlert({
    super.key,
    required this.state,
  });

  final AnimeState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.stateImage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      state.stateImage,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const LoadingGradient(),
                  ],
                ),
              ),
            ),
          Text(
            state.stateMessage,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

@immutable
class LoadingGradient extends StatelessWidget {
  const LoadingGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          stops: const [0.8, 0.9, 1.0],
          colors: [
            Colors.transparent,
            Colors.transparent,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: const SizedBox(height: 200, width: 200),
    );
  }
}
