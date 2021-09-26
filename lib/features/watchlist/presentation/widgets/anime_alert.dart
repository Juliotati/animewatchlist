part of presentation;

class AnimeAlert extends StatelessWidget {
  const AnimeAlert(this.data, {Key? key}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}
