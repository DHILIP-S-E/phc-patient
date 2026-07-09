plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.gramcare.phc_patient"
    // 36 and NDK 29 are required by the ported offline-assistant plugins
    // (flutter_tts, speech_to_text, whisper_ggml) — see phc_ai_assistant's own
    // android/app/build.gradle.kts, which this native build config is merged from.
    compileSdk = 36
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gramcare.phc_patient"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // 26+ required for the on-device Gemma/llama.cpp inference.
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Native build configuration for llama.cpp (offline assistant).
        externalNativeBuild {
            cmake {
                cppFlags += listOf("-std=c++17", "-O3") // no -ffast-math: breaks ggml
                arguments += listOf(
                    "-DANDROID_STL=c++_shared",
                    "-DLLAMA_NATIVE=OFF",
                    "-DGGML_BLAS=OFF",
                    "-DGGML_CUDA=OFF",
                    "-DGGML_METAL=OFF"
                )
                // arm64 only, matching phc_ai_assistant: armv7 fails on FP16 NEON
                // intrinsics; add more ABIs back for a production/store build.
                abiFilters += listOf("arm64-v8a")
            }
        }
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
    }

    // External native build — llama.cpp via CMake (offline assistant bridge).
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            // Keep false — minification breaks FFI symbol lookup (Dart FFI looks
            // up phc_* symbols by name at runtime).
            isMinifyEnabled = false
        }
    }

    // Allow large model-related assets (not packaged in APK, but good practice).
    aaptOptions {
        noCompress += listOf("gguf", "bin", "model")
    }

    packaging {
        jniLibs {
            // Keep native .so files uncompressed for faster loading.
            useLegacyPackaging = false
        }
    }
}

flutter {
    source = "../.."
}
