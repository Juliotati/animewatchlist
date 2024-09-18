import 'package:animewatchlist/core/config/di/app_di.dart';
import 'package:animewatchlist/core/links.dart';
import 'package:animewatchlist/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web/web.dart' as web;

final logMin = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    lineLength: 40,
  ),
);

final class AppEnv {
  const AppEnv._();

  static bool get isProduction => kReleaseMode;

  static bool get isDevelopment => kDebugMode;

  static bool get isStaging => kProfileMode;
}

class AppConfig {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    setPathUrlStrategy();

    /// TODO(Jùlio): Maybe add go router so this is not here like this
    redirectStrategy;

    await setupGetIt();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      logMin.i('INITIALIZED FIREBASE APP');
    } catch (error) {
      logMin.e(
        'UNABLE TO INITIALIZE FIREBASE APP',
        error: [error, StackTrace.current],
      );
    }
  }

  static String? get redirectStrategy {
    final base = Uri.base;
    if (base.host.contains(Links.firebaseHostname) ||
        base.host.contains(Links.firebaseAppHostname)) {
      web.window.location.replace(Links.app);
    }

    return null;
  }
}
