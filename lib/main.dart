import 'package:animewatchlist/core/config/di/app_di.dart';
import 'package:animewatchlist/features/watchlist/watchlist.dart';
import 'package:animewatchlist/features/watchlist/presentation/provider/watchlist_provider.dart';
import 'package:animewatchlist/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupGetIt();
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
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: ListenableProvider<WatchlistProvider>(
        create: (_) => sl.get<WatchlistProvider>(),
        child: const WatchlistScreen(),
      ),
    );
  }
}
