import 'package:animewatchlist/core/config/app_config.dart';
import 'package:animewatchlist/core/config/di/app_di.dart';
import 'package:animewatchlist/features/watchlist/presentation/provider/watchlist_provider.dart';
import 'package:animewatchlist/features/watchlist/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:link_target/link_target.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await AppConfig.initialize();
  runApp(const AnimeArchive());
  SemanticsBinding.instance.ensureSemantics();
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
      home: MultiProvider(
        providers: [
          ListenableProvider<WatchlistProvider>(
            create: (_) => sl.get<WatchlistProvider>(),
          ),
        ],
        child: const LinkTargetRegion(child: WatchlistScreen()),
      ),
    );
  }
}
