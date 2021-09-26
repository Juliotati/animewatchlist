import 'package:animewatchlist/features/watchlist/data/datasources/datasource_watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/local_datasource.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalDatasourceImpl(AnimeWatchList.instance);
  runApp(AnimeArchive());
}

class AnimeArchive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '9Anime Watchlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder<List<WatchListModel>>(
          future: LocalDatasourceImpl(AnimeWatchList.instance).getAllAnimes(),
          builder: (BuildContext context,
              AsyncSnapshot<List<WatchListModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('LOADING'));
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('ERROR - COULD NOT LOAD WATCHLIST'),
              );
            }
            if (snapshot.data!.isEmpty || !snapshot.hasData) {
              return const Center(child: Text('WATCHLIST IS EMPTY'));
            }
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, int i) {
                final List<WatchListModel> list = snapshot.data!;
                if (list[i].folder != list[i + 1].folder) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${snapshot.data![i].folder.toUpperCase()} - ${snapshot.data![i].links.length}',
                      style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),

                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (BuildContext context, int i) {
                final List<WatchListModel> data = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data[i].links.map((String link) {
                        if (link == '') {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          link
                              .substring(
                                  'http://myanimelist.net/anime/'.length + 6)
                              .replaceAll('_', ' '),
                      style: Theme.of(context).textTheme.headline6,
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
