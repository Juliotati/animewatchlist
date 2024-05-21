library watchlist;

import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:animewatchlist/core/core.dart';
import 'package:animewatchlist/core/use_cases/use_case.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist.dart';
import 'package:animewatchlist/features/watchlist/data/models/watchlist_category.dart';
import 'package:animewatchlist/features/watchlist/presentation/provider/watchlist_provider.dart';
import 'package:animewatchlist/gen/assets.gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

part 'data/data_sources/local_datasource.dart';
part 'data/data_sources/remote_datasource.dart';
part 'data/data_sources/watchlist.dart';
part 'data/repositories/watchlist_repository_impl.dart';
part 'domain/repositories/watchlist_repository.dart';
part 'domain/use_cases/get_watchlist.dart';
part 'presentation/provider/watchlist_folder_type.dart';
part 'presentation/provider/watchlist_state.dart';
part 'presentation/screens/watchlist.dart';
part 'presentation/widgets/anime_alert.dart';
part 'presentation/widgets/anime_preview.dart';
part 'presentation/widgets/anime_separator.dart';
part 'presentation/widgets/grouped_anime.dart';
part 'presentation/widgets/top_recommended_anime.dart';
part 'presentation/widgets/watchlist_card.dart';
