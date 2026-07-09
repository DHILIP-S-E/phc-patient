plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.phcai.phc_ai_assistant"
    compileSdk = 36  // several plugins (flutter_tts, speech_to_text...) require 36
    ndkVersion = "29.0.13113456"  // highest required by plugins (whisper_ggml)

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.phcai.phc_ai_assistant"
        minSdk = 26          // Android 8.0+ for better AI performance
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Native build configuration for llama.cpp
        externalNativeBuild {
            cmake {
                cppFlags += listOf("-std=c++17", "-O3")  // no -ffast-math: breaks ggml
                arguments += listOf(
                    "-DANDROID_STL=c++_shared",
                    "-DLLAMA_NATIVE=OFF",
                    "-DGGML_BLAS=OFF",
                    "-DGGML_CUDA=OFF",
                    "-DGGML_METAL=OFF"
                )
                // arm64 only: this is what actually restricts the CMake native
                // build. armv7 (armeabi-v7a) fails on FP16 NEON intrinsics and
                // your phone is arm64 anyway.
                abiFilters += listOf("arm64-v8a")
            }
        }

        // ABI filters for packaging — arm64-v8a only (your test phone is arm64).
        // Add "armeabi-v7a"/"x86_64" back for a production/store build.
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
    }

    // External native build — llama.cpp via CMake
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            isJniDebuggable = true
        }
        release {
            isMinifyEnabled = false  // Keep false — minification breaks FFI symbol lookup
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // Allow large model-related assets (not packaged in APK, but good practice)
    aaptOptions {
        noCompress += listOf("gguf", "bin", "model")
    }

    packaging {
        resources {
            excludes += setOf("/META-INF/{AL2.0,LGPL2.1}")
        }
        jniLibs {
            // Keep native .so files uncompressed for faster loading
            useLegacyPackaging = false
        }
    }
}

flutter {
    source = "../.."
}
