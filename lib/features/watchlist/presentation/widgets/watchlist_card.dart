part of presentation;

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: const Color.fromRGBO(255, 255, 255, 0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        child: child,
      ),
    );
  }
}
