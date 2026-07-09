# Flutter FFI rules — preserve all native bridge symbols
-keep class com.phcai.phc_ai_assistant.** { *; }

# Dart FFI — do not strip native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# llama.cpp symbols (exported from libphc_llama.so)
-keep class ** {
    @com.sun.jna.* *;
}

# Prevent R8 from optimizing away Flutter plugin code
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# speech_to_text
-keep class com.csdcorp.speech_to_text.** { *; }

# flutter_tts
-keep class com.tundralabs.fluttertts.** { *; }

# Keep data classes intact
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
