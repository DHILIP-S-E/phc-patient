// ============================================================
// PHC AI Assistant - Model Constants
// All configuration for the Gemma 3 1B GGUF model lifecycle
// ============================================================

class ModelConstants {
  ModelConstants._();

  // ── Model Identity ────────────────────────────────────────
  static const String modelName = 'Gemma 3 1B Healthcare';
  static const String modelVersion = '1.0.0';
  static const String modelFileName = 'gemma3-1b-phc-v2-q4_k_m.gguf';
  static const String modelDirectory = 'phc_models';

  // ── Download Configuration ────────────────────────────────
  /// Replace with your actual hosted GGUF model URL.
  /// Supports chunked/range requests for pause-resume.
  /// Hugging Face public download URL for the retrained v2 GGUF.
  static const String modelDownloadUrl =
      'https://huggingface.co/DHILIP-S-E/finetune-phc/resolve/main/gemma3-1b-phc-v2-q4_k_m.gguf';

  /// SHA-256 of gemma3-1b-phc-v2-q4_k_m.gguf (the RETRAINED v2 model).
  static const String modelChecksum =
      '31fef2352ffcddb6508cf08204148bce216161ee129780e3d7dbe7e51badef13';

  /// Exact size in bytes of gemma3-1b-phc-v2-q4_k_m.gguf (Q4_K_M of the 1B model).
  static const int modelSizeBytes = 806058944;

  // ── Model Metadata URL (for version checking) ─────────────
  static const String modelMetaUrl =
      'https://storage.phcai.in/models/latest.json';

  // ── llama.cpp Inference Parameters ───────────────────────
  // Kept SMALL for phone RAM. n_ctx=2048 + n_batch=512 blew past the memory
  // budget on top of the 768MB model and the OS killed the process mid-inference.
  static const int nCtx = 1024;         // context window (smaller KV cache)
  static const int nBatch = 256;        // prompt batch (smaller compute buffer)
  // IMPORTANT: keep this BELOW the phone's core count so the UI thread isn't
  // starved. At 6 threads the inference saturated every core, so Flutter couldn't
  // render — the streamed tokens piled up invisibly and dumped all at once, the UI
  // froze, and it felt like a long wait. 4 leaves cores free for smooth streaming
  // + interruption, and -O3 keeps it fast. Do NOT raise this to match core count.
  static const int nThreads = 4;        // CPU threads (leave headroom for the UI)
  static const int nGpuLayers = 0;      // GPU layers (0 = CPU only, broad compatibility)
  static const double temperature = 0.7;
  static const double topP = 0.9;
  static const double repeatPenalty = 1.3; // 1.1 was too weak -> looping
  static const int maxNewTokens = 64;   // this phone is ~1 tok/s; keep answers short
  static const bool useFlashAttn = false; // Disable for compatibility

  // ── Memory Management ─────────────────────────────────────
  /// Unload model if RAM pressure exceeds this threshold (bytes)
  static const int memoryPressureThresholdBytes = 50 * 1024 * 1024; // 50MB free

  // ── Download Chunk Size ───────────────────────────────────
  static const int downloadChunkSize = 8 * 1024 * 1024; // 8MB chunks

  // ── Retry Configuration ───────────────────────────────────
  static const int maxDownloadRetries = 3;
  static const Duration retryDelay = Duration(seconds: 5);

  // ── Healthcare System Prompt ──────────────────────────────
  // Kept SHORT on purpose. A long system prompt is re-processed on every message
  // and is a major cause of slow responses on a phone CPU. This concise version
  // keeps the essential rules.
  // Kept short: every character here is re-tokenized and re-decoded on the phone
  // CPU for every message, so a long prompt adds latency. The language rule is
  // stated BOTH in English AND in the target language's own script — giving the
  // instruction in-script is the strongest way to make Gemma answer in that
  // language (e.g. Tamil) instead of defaulting to English.
  static String healthcareSystemPrompt(String language) {
    final langName = _languageFullName(language);
    final native = _nativeReplyInstruction(language);
    return "You are Aarogya, a health helper for Indian PHCs. "
        "You MUST reply ONLY in $langName. Do not use English unless the language is English. "
        "Use simple words, 2-3 short sentences. "
        "Never diagnose or prescribe. For serious symptoms, tell them to visit the nearest PHC. "
        "$native";
  }

  /// The "reply only in this language" instruction written IN that language's
  /// script. Placing it last (recency) strongly biases the reply language.
  static String _nativeReplyInstruction(String code) {
    const m = {
      'en': 'Reply only in English.',
      'ta': 'தமிழில் மட்டும் பதிலளியுங்கள்.',
      'hi': 'केवल हिंदी में उत्तर दें।',
      'te': 'తెలుగులో మాత్రమే సమాధానం ఇవ్వండి.',
      'ml': 'മലയാളത്തിൽ മാത്രം മറുപടി നൽകുക.',
      'kn': 'ಕನ್ನಡದಲ್ಲಿ ಮಾತ್ರ ಉತ್ತರಿಸಿ.',
      'bn': 'শুধুমাত্র বাংলায় উত্তর দিন।',
      'gu': 'ફક્ત ગુજરાતીમાં જ જવાબ આપો.',
      'mr': 'फक्त मराठीत उत्तर द्या.',
      'pa': 'ਸਿਰਫ਼ ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦਿਓ।',
      'or': 'କେବଳ ଓଡ଼ିଆରେ ଉତ୍ତର ଦିଅନ୍ତୁ।',
      'ur': 'صرف اردو میں جواب دیں۔',
    };
    return m[code] ?? m['en']!;
  }

  static String _languageFullName(String code) {
    const names = {
      'ta': 'Tamil',
      'en': 'English',
      'hi': 'Hindi',
      'te': 'Telugu',
      'ml': 'Malayalam',
      'kn': 'Kannada',
      'bn': 'Bengali',
      'gu': 'Gujarati',
      'mr': 'Marathi',
      'pa': 'Punjabi',
      'or': 'Odia',
      'ur': 'Urdu',
    };
    return names[code] ?? 'English';
  }
}
