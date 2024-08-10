part of 'link_target_provider.dart';

@immutable
final class LinkTargetWrapper extends StatelessWidget {
  const LinkTargetWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return Stack(
      children: [
        child,
        Positioned(
          left: 0.0,
          bottom: 0.0,
          child: Consumer<LinkTargetProvider>(
            builder: (context, provider, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 300),
                child: !provider.hasTarget
                    ? SizedBox.shrink(key: UniqueKey())
                    : Card(
                        elevation: 0.0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            provider.linkTarget,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

@immutable
class LinkTargetHover extends StatelessWidget {
  const LinkTargetHover({
    required this.child,
    required this.linkTarget,
    super.key,
  });

  final Widget child;
  final String linkTarget;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        context.read<LinkTargetProvider>().onHover(linkTarget);
      },
      onExit: (_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!context.mounted) return;
          context.read<LinkTargetProvider>().onExit(linkTarget);
        });
      },
      child: child,
    );
  }
}
