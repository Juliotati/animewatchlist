import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AnimeArchive());
}

class AnimeArchive extends StatelessWidget {
  const AnimeArchive();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Watchlist',
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const WatchlistScreen(),
    );
  }
}
