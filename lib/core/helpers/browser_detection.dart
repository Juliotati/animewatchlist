/// The core Browser Detection functionality from the Flutter web engine.
class BrowserDetection {
  BrowserDetection._();

  /// The singleton instance of the [BrowserDetection] class.
  static final BrowserDetection instance = BrowserDetection._();

  /// A flag to check if the current [operatingSystem] is a laptop/desktop
  /// operating system.
  bool get isDesktop => false;

  /// A flag to check if the current browser is running on a mobile device.
  ///
  /// Flutter web considers "mobile" everything that not [isDesktop].
  bool get isMobile => true;

  /// Whether the current [browserEngine] is [BrowserEngine.blink] (Chrom(e|ium)).
  bool get isChromium => false;

  /// Whether the current [browserEngine] is [BrowserEngine.webkit] (Safari).
  bool get isSafari => false;

  /// Whether the current [browserEngine] is [BrowserEngine.firefox].
  bool get isFirefox => false;

  /// Whether the current browser is Edge.
  bool get isEdge => false;

  /// Whether we are running from a wasm module compiled with dart2wasm.
  bool get isWasm => false;
}
