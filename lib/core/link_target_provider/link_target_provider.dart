library link_target_provider;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'link_target_wrapper.dart';

final class LinkTargetProvider extends ChangeNotifier {
  String _linkTarget = '';

  bool get hasTarget => _linkTarget.isNotEmpty;

  String get linkTarget => _linkTarget;

  void onHover(String value) {
    _linkTarget = value;
    notifyListeners();
  }

  void onExit(String linkTarget) {
    if (_linkTarget == linkTarget) {
      _linkTarget = '';
    }
    notifyListeners();
  }
}
