part of '../presentation.dart';

class AnimeAlert extends StatelessWidget {
  const AnimeAlert(this.data, {super.key});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}
