/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsLoadingGifsGen {
  const $AssetsLoadingGifsGen();

  /// File path: assets/loading_gifs/azurlane.gif
  AssetGenImage get azurlane =>
      const AssetGenImage('assets/loading_gifs/azurlane.gif');

  /// File path: assets/loading_gifs/bullet_load.gif
  AssetGenImage get bulletLoad =>
      const AssetGenImage('assets/loading_gifs/bullet_load.gif');

  /// File path: assets/loading_gifs/desert_gun.gif
  AssetGenImage get desertGun =>
      const AssetGenImage('assets/loading_gifs/desert_gun.gif');

  /// File path: assets/loading_gifs/hokage_naruto.gif
  AssetGenImage get hokageNaruto =>
      const AssetGenImage('assets/loading_gifs/hokage_naruto.gif');

  /// File path: assets/loading_gifs/hum_naruto.gif
  AssetGenImage get humNaruto =>
      const AssetGenImage('assets/loading_gifs/hum_naruto.gif');

  /// File path: assets/loading_gifs/luffy_search.gif
  AssetGenImage get luffySearch =>
      const AssetGenImage('assets/loading_gifs/luffy_search.gif');

  /// File path: assets/loading_gifs/meaty_eye.gif
  AssetGenImage get meatyEye =>
      const AssetGenImage('assets/loading_gifs/meaty_eye.gif');

  /// File path: assets/loading_gifs/naruto_vs_sasuke.gif
  AssetGenImage get narutoVsSasuke =>
      const AssetGenImage('assets/loading_gifs/naruto_vs_sasuke.gif');

  /// File path: assets/loading_gifs/zoro_sishui.gif
  AssetGenImage get zoroSishui =>
      const AssetGenImage('assets/loading_gifs/zoro_sishui.gif');

  /// File path: assets/loading_gifs/zoro_workout.gif
  AssetGenImage get zoroWorkout =>
      const AssetGenImage('assets/loading_gifs/zoro_workout.gif');

  /// List of all assets
  List<AssetGenImage> get values => [
        azurlane,
        bulletLoad,
        desertGun,
        hokageNaruto,
        humNaruto,
        luffySearch,
        meatyEye,
        narutoVsSasuke,
        zoroSishui,
        zoroWorkout
      ];
}

class Assets {
  Assets._();

  static const $AssetsLoadingGifsGen loadingGifs = $AssetsLoadingGifsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
