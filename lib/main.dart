import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/local_datasource.dart';
import 'package:animewatchlist/features/watchlist/presentation/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LocalDatasourceImpl.instance.source = AnimeWatchList.instance;

  runApp(const AnimeArchive());
}

class AnimeArchive extends StatelessWidget {
  const AnimeArchive();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime Watchlist',
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const WatchlistScreen());
  }
}
