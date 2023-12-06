// ignore_for_file: always_use_package_imports
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app_di.config.dart';

final sl = GetIt.instance;

@InjectableInit(
  asExtension: false,
  initializerName: 'initGetIt',
  throwOnMissingDependencies: false,
)
Future<void> setupGetIt([String env = Environment.prod]) async {
  initGetIt(sl, environment: env);
}
