part of '../core.dart';

class AppException implements Exception {
  AppException([this.message]);

  String? message;

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) {
      return 'Make sure LocalDatasourceImpl is initialized on launch by calling "LocalDatasourceImpl.instance.source = AnimeWatchList.instance"';
    }
    return 'Exception: $message';
  }
}
