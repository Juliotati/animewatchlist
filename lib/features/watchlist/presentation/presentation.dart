library presentation;

import 'dart:io';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/features/watchlist/data/datasources/local_datasource.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

part 'provider/folder.dart';
part 'screens/watchlist.dart';
part 'widgets/all_anime.dart';
part 'widgets/recommended_anime.dart';
part 'widgets/anime_alert.dart';
part 'widgets/anime_name.dart';
part 'widgets/anime_separator.dart';
part 'widgets/watchlist_card.dart';
