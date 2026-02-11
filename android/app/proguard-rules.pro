# Flutter specific rules for R8.
# https://docs.flutter.dev/deployment/android#enabling-r8-and-obfuscating-code
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }
-keep class com.google.firebase.** { *; }
-dontwarn io.flutter.embedding.**
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.android.gms.ads.** { *; }
-keep class androidx.browser.customtabs.CustomTabsIntent { *; }

## Glide
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public class * extends com.bumptech.glide.module.LibraryGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$ImageType
-keep public @com.bumptech.glide.annotation.GlideExtension class * {
    @com.bumptech.glide.annotation.GlideType *;
}
-keepclassmembers class * {
    @com.bumptech.glide.annotation.GlideType *;
}
-keepclassmembers public class * implements com.bumptech.glide.load.model.ModelLoader {
    public <init>(android.content.Context, com.bumptech.glide.load.engine.executor.GlideExecutor);
    public <init>(android.content.Context);
    public <init>(android.content.res.Resources, com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool);
    public <init>(com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool);
}
-keep public class com.bumptech.glide.load.data.ExifOrientationStream
-keepclasseswithmembernames class * {
    @com.bumptech.glide.annotation.GlideModule <methods>;
}
-keep public class * implements com.bumptech.glide.load.resource.transcode.ResourceTranscoder {
    public <init>();
}
-keep public class * implements com.bumptech.glide.provider.DataLoadProvider {
    public <init>();
}
-keep public class * implements com.bumptech.glide.load.Encoder {
    public <init>();
}
-keep public class * implements com.bumptech.glide.load.ResourceEncoder {
    public <init>();
}
-keep public class * implements com.bumptech.glide.load.ResourceDecoder {
    public <init>(com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool);
}

# Link Preview
-keep class org.jsoup.** { *; }
-dontwarn org.jsoup.**

# App specific rules.
