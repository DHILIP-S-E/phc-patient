cmake_minimum_required(VERSION 3.22.1)
project(phc_llama VERSION 1.0.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ── Android-specific optimization flags ──────────────────────
# NOTE: do NOT use -ffast-math here. It implies -ffinite-math-only, which ggml
# rejects ("routines require non-finite math arithmetics"), and it changes FP
# semantics in ways that can corrupt inference. -O3 is enough.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -DNDEBUG")

# ── CRITICAL PERFORMANCE FIX ──────────────────────────────────
# Android/Gradle compiles native code with CMAKE_BUILD_TYPE=Debug for a normal
# `flutter run`. That sets -O0 -g on ggml/llama.cpp, making on-device inference
# 10-50x SLOWER (minutes per reply instead of seconds). The global -O3 above is
# cancelled because the Debug config appends -O0 afterwards (last -O wins).
# Overriding the PER-CONFIG flags forces full optimization in every build type,
# so even the debug build runs at release speed — this is why other llama.cpp
# apps feel instant on the same phone. Must be set BEFORE add_subdirectory() so
# the llama.cpp submodule inherits it.
set(CMAKE_C_FLAGS_DEBUG          "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG        "-O3 -DNDEBUG")
set(CMAKE_C_FLAGS_RELEASE        "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE      "-O3 -DNDEBUG")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -DNDEBUG")

# ARM NEON optimization (most Android phones)
if(ANDROID_ABI STREQUAL "arm64-v8a")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8-a+dotprod+fp16")
    message(STATUS "Building for ARM64 with NEON/dotprod")
elseif(ANDROID_ABI STREQUAL "armeabi-v7a")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv7-a -mfpu=neon")
    message(STATUS "Building for ARMv7 with NEON")
elseif(ANDROID_ABI STREQUAL "x86_64")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mavx2")
    message(STATUS "Building for x86_64 with AVX2")
endif()

# ── llama.cpp configuration ───────────────────────────────────
# Set to OFF for Android (CPU-only, no BLAS/CUDA/Metal)
set(LLAMA_NATIVE OFF CACHE BOOL "")
set(LLAMA_BUILD_TESTS OFF CACHE BOOL "")
set(LLAMA_BUILD_EXAMPLES OFF CACHE BOOL "")
set(LLAMA_BUILD_SERVER OFF CACHE BOOL "")
set(GGML_BLAS OFF CACHE BOOL "")
set(GGML_CUDA OFF CACHE BOOL "")
set(GGML_METAL OFF CACHE BOOL "")
set(GGML_VULKAN OFF CACHE BOOL "")
set(GGML_OPENMP OFF CACHE BOOL "")

# llama.cpp as subdirectory (git submodule at android/llama.cpp/)
add_subdirectory(
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../llama.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/llama.cpp
)

# ── PHC Bridge Library ─────────────────────────────────────────
add_library(
    phc_llama
    SHARED
    llama_bridge.cpp
)

target_include_directories(phc_llama PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../llama.cpp/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../llama.cpp/ggml/include
)

target_link_libraries(phc_llama
    llama
    ggml
    android
    log
)

# NOTE: do NOT hide symbols here. "CXX_VISIBILITY_PRESET hidden" + -fvisibility=hidden
# hid the phc_* bridge functions, so Dart FFI could not find them at runtime
# ("undefined symbol: phc_load_model"). The phc_* API must stay exported.
# The functions are also individually marked visibility("default") in the .cpp as
# belt-and-suspenders.

message(STATUS "PHC llama bridge configured for ABI: ${ANDROID_ABI}")
