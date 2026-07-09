/*
 * PHC AI Assistant - llama.cpp JNI/FFI Bridge
 * Exposes llama.cpp inference functions to Flutter FFI
 *
 * Build: CMakeLists.txt compiles this with llama.cpp sources
 * Usage: Dart FFI loads libphc_llama.so at runtime
 */

#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

#include <android/log.h>

// Include llama.cpp header (submodule)
#include "llama.h"

// ── Logging ───────────────────────────────────────────────────
// These show up in `adb logcat` under the tag "phc_llama". Filter with:
//   adb logcat -s phc_llama
#define PHC_TAG "phc_llama"
#define PHC_LOGI(...) __android_log_print(ANDROID_LOG_INFO,  PHC_TAG, __VA_ARGS__)
#define PHC_LOGE(...) __android_log_print(ANDROID_LOG_ERROR, PHC_TAG, __VA_ARGS__)

// Export marker for FFI visibility. Force default visibility on every exported
// symbol so Dart FFI can always resolve them, even if a parent CMake (e.g.
// llama.cpp's) injects -fvisibility=hidden globally.
#define PHC_EXPORT __attribute__((visibility("default"), used))

#ifdef __cplusplus
extern "C" {
#endif

// ── Model / context lifecycle wrappers ────────────────────────
// These exist because llama_load_model_from_file / llama_new_context_with_model
// take their *_params structs BY VALUE, which cannot be passed correctly from
// Dart FFI (Dart would pass a pointer). These wrappers build the params structs
// natively with sane defaults and take only simple scalar args.

static bool g_backend_inited = false;

/// Load a GGUF model from disk (CPU-only). Returns nullptr on failure.
PHC_EXPORT llama_model* phc_load_model(const char* path) {
    if (!path) { PHC_LOGE("phc_load_model: null path"); return nullptr; }
    if (!g_backend_inited) { llama_backend_init(); g_backend_inited = true; }
    PHC_LOGI("phc_load_model: loading GGUF from %s", path);
    llama_model_params mparams = llama_model_default_params();
    mparams.n_gpu_layers = 0;                 // phones: CPU only
    llama_model* m = llama_load_model_from_file(path, mparams);
    if (!m) {
        PHC_LOGE("phc_load_model: llama_load_model_from_file returned NULL "
                 "(missing/corrupt GGUF or out of memory)");
    } else {
        PHC_LOGI("phc_load_model: model loaded OK");
    }
    return m;
}

/// Create an inference context. Returns nullptr on failure.
PHC_EXPORT llama_context* phc_new_context(llama_model* model, int n_ctx,
                               int n_threads, int n_batch) {
    if (!model) return nullptr;
    llama_context_params cparams = llama_context_default_params();
    cparams.n_ctx = n_ctx > 0 ? (uint32_t)n_ctx : 2048;
    cparams.n_batch = n_batch > 0 ? (uint32_t)n_batch : 512;
    cparams.n_threads = n_threads > 0 ? n_threads : 4;
    cparams.n_threads_batch = cparams.n_threads;
    return llama_new_context_with_model(model, cparams);
}

/// Free an inference context.
PHC_EXPORT void phc_free_context(llama_context* ctx) {
    if (ctx) llama_free(ctx);
}

/// Free a loaded model.
PHC_EXPORT void phc_free_model_wrapper(llama_model* model) {
    if (model) llama_free_model(model);
}

/*
 * phc_generate_response
 *
 * Runs synchronous inference using the loaded llama context.
 * Returns heap-allocated C string that caller must free via phc_free_string().
 *
 * Parameters:
 *   ctx          - Loaded llama context
 *   model        - Loaded llama model
 *   system_prompt - Healthcare system prompt (UTF-8)
 *   user_message  - User input message (UTF-8)
 *   max_tokens    - Maximum tokens to generate
 *   temperature   - Sampling temperature (0.0 - 2.0)
 *   top_p         - Nucleus sampling top-p (0.0 - 1.0)
 *   repeat_penalty - Penalty for repeating tokens (1.0 = off, 1.3 = strong).
 *                    REQUIRED to stop small models looping ("SourceSource...").
 */
PHC_EXPORT const char* phc_generate_response(
    llama_context* ctx,
    llama_model* model,
    const char* system_prompt,
    const char* user_message,
    int max_tokens,
    float temperature,
    float top_p,
    float repeat_penalty
) {
    if (!ctx || !model || !user_message) {
        PHC_LOGE("phc_generate_response: invalid params (ctx=%p model=%p user=%p)",
                 (void*)ctx, (void*)model, (const void*)user_message);
        return strdup("Error: Invalid parameters");
    }
    PHC_LOGI("phc_generate_response: user_message=\"%s\" max_tokens=%d temp=%.2f "
             "top_p=%.2f rep=%.2f", user_message, max_tokens, temperature,
             top_p, repeat_penalty);

    // Build a GEMMA-3 prompt. Gemma uses <start_of_turn>/<end_of_turn> and has
    // NO separate system role, so the system prompt is folded into the first
    // user turn. (The old <|system|>/<|user|> markers were Phi/ChatML, not Gemma,
    // and caused garbage/looping output because they don't match training.)
    std::string prompt = "<start_of_turn>user\n";
    if (system_prompt && strlen(system_prompt) > 0) {
        prompt += system_prompt;
        prompt += "\n\n";
    }
    prompt += user_message;
    prompt += "<end_of_turn>\n<start_of_turn>model\n";

    // These token functions moved from taking llama_model* to const llama_vocab*
    // in this llama.cpp version, so fetch the vocab once and use it below.
    const llama_vocab* vocab = llama_model_get_vocab(model);

    // Tokenize prompt
    const int n_ctx = llama_n_ctx(ctx);
    std::vector<llama_token> tokens(n_ctx);
    int n_tokens = llama_tokenize(
        vocab,
        prompt.c_str(),
        static_cast<int>(prompt.size()),
        tokens.data(),
        static_cast<int>(tokens.size()),
        /*add_bos=*/true,
        /*special=*/true
    );

    if (n_tokens < 0) {
        PHC_LOGE("phc_generate_response: tokenization failed (prompt too long for "
                 "n_ctx=%d? needed %d)", n_ctx, -n_tokens);
        return strdup("Error: Tokenization failed");
    }
    tokens.resize(n_tokens);
    PHC_LOGI("phc_generate_response: prompt tokenized to %d tokens (n_ctx=%d)",
             n_tokens, n_ctx);

    // Clear KV cache and decode prompt.
    PHC_LOGI("phc_generate_response: clearing memory...");
    llama_memory_clear(llama_get_memory(ctx), true);
    PHC_LOGI("phc_generate_response: memory cleared");

    // Decode the prompt in n_batch-sized chunks. A single llama_decode() batch
    // must not exceed n_batch, or llama.cpp asserts/crashes. The system prompt
    // alone can be larger than n_batch, so chunking is required.
    const int n_batch_sz = (int) llama_n_batch(ctx);
    PHC_LOGI("phc_generate_response: decoding prompt in chunks of %d", n_batch_sz);
    for (int i = 0; i < n_tokens; i += n_batch_sz) {
        int chunk = n_tokens - i;
        if (chunk > n_batch_sz) chunk = n_batch_sz;
        llama_batch batch = llama_batch_get_one(tokens.data() + i, chunk);
        int decode_res = llama_decode(ctx, batch);
        if (decode_res != 0) {
            PHC_LOGE("phc_generate_response: prompt decode failed at token %d/%d",
                     i, n_tokens);
            return strdup("Error: Prompt decode failed");
        }
    }
    PHC_LOGI("phc_generate_response: prompt decoded successfully. Initializing sampler...");

    // Sampling parameters. Order: penalties -> top_p -> temp -> dist.
    // The penalties sampler is what stops the "SourceSourceSource..." loop.
    llama_sampler_chain_params sparams = llama_sampler_chain_default_params();
    llama_sampler* sampler = llama_sampler_chain_init(sparams);
    // penalty_last_n=64, penalty_repeat=repeat_penalty, freq=0, present=0.
    // NOTE: if your llama.cpp version has a different llama_sampler_init_penalties
    // signature, adjust these args to match your submodule.
    llama_sampler_chain_add(sampler, llama_sampler_init_penalties(
        /*penalty_last_n=*/64,
        /*penalty_repeat=*/repeat_penalty,
        /*penalty_freq=*/0.0f,
        /*penalty_present=*/0.0f));
    llama_sampler_chain_add(sampler, llama_sampler_init_top_p(top_p, 1));
    llama_sampler_chain_add(sampler, llama_sampler_init_temp(temperature));
    llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

    // Generate tokens
    std::string response;
    response.reserve(512);

    int n_generated = 0;
    const llama_token eos = llama_vocab_eos(vocab);
    const llama_token eot = llama_vocab_eot(vocab);
    // Stop before the KV cache (n_ctx) fills, so we never decode past the context
    // and hit a hard failure. prompt tokens already occupy n_tokens slots.
    const int n_ctx_max = (int) llama_n_ctx(ctx);

    PHC_LOGI("phc_generate_response: sampler initialized. Entering generation loop...");
    while (n_generated < max_tokens && (n_tokens + n_generated) < n_ctx_max) {
        // non-const: llama_batch_get_one() below needs a non-const llama_token*
        llama_token new_token = llama_sampler_sample(sampler, ctx, -1);

        if (new_token == eos || new_token == eot) {
            PHC_LOGI("phc_generate_response: hit EOS/EOT token at count %d", n_generated);
            break;
        }

        // Convert token to text. special=false so control tokens like
        // <start_of_turn>/<end_of_turn> render as EMPTY instead of leaking their
        // literal text into the reply.
        char piece[256];
        int piece_len = llama_token_to_piece(
            vocab, new_token, piece, sizeof(piece), 0, false
        );

        if (piece_len > 0) {
            response.append(piece, piece_len);
        }

        // Decode next token
        llama_batch next_batch = llama_batch_get_one(&new_token, 1);
        int decode_res = llama_decode(ctx, next_batch);
        if (decode_res != 0) {
            PHC_LOGE("phc_generate_response: decode failed after %d generated tokens",
                     n_generated);
            break;
        }

        n_generated++;

        // Heartbeat: proves generation is alive and lets you measure tok/s.
        // If this stops ticking, generation stalled at that token count.
        if ((n_generated % 8) == 0) {
            PHC_LOGI("phc_generate_response: …generating, %d tokens so far",
                     n_generated);
        }
    }

    llama_sampler_free(sampler);
    PHC_LOGI("phc_generate_response: generated %d tokens", n_generated);

    // Trim whitespace
    size_t start = response.find_first_not_of(" \n\r\t");
    if (start == std::string::npos) {
        PHC_LOGE("phc_generate_response: EMPTY response (model produced only "
                 "whitespace / hit EOS immediately)");
        return strdup("");
    }
    size_t end = response.find_last_not_of(" \n\r\t");
    response = response.substr(start, end - start + 1);

    PHC_LOGI("phc_generate_response: reply=\"%s\"", response.c_str());
    return strdup(response.c_str());
}

// ── Streaming generation API ──────────────────────────────────
// Token-by-token generation so Dart can display words as they are produced
// instead of waiting for the whole reply. Flow from Dart (one generation at a
// time, guarded by the Dart _isGenerating lock):
//   phc_stream_start(...)  -> tokenize + decode prompt + init sampler
//   loop: phc_stream_next(...) -> returns next piece (strdup) or nullptr at end
//   phc_stream_finish()    -> free sampler
// The generation state lives in these globals; only ONE stream may run at once.
static llama_sampler* g_sampler = nullptr;
static int  g_stream_generated = 0;
static int  g_stream_prompt_n  = 0;
static llama_token g_stream_eos = 0;
static llama_token g_stream_eot = 0;
// Set from Dart (main isolate) to abort an in-flight generation for barge-in /
// "stop". Process-global, so the worker isolate's loop sees it immediately.
static volatile bool g_stream_cancel = false;

/// Begin a streaming generation. Returns 0 on success, negative on error.
PHC_EXPORT int phc_stream_start(
    llama_context* ctx,
    llama_model* model,
    const char* system_prompt,
    const char* user_message,
    float temperature,
    float top_p,
    float repeat_penalty
) {
    if (!ctx || !model || !user_message) {
        PHC_LOGE("phc_stream_start: invalid params");
        return -1;
    }
    // Reset any leftover sampler from a previous (aborted) stream.
    if (g_sampler) { llama_sampler_free(g_sampler); g_sampler = nullptr; }
    g_stream_generated = 0;
    g_stream_cancel = false;

    std::string prompt = "<start_of_turn>user\n";
    if (system_prompt && strlen(system_prompt) > 0) {
        prompt += system_prompt;
        prompt += "\n\n";
    }
    prompt += user_message;
    prompt += "<end_of_turn>\n<start_of_turn>model\n";

    const llama_vocab* vocab = llama_model_get_vocab(model);
    const int n_ctx = llama_n_ctx(ctx);
    std::vector<llama_token> tokens(n_ctx);
    int n_tokens = llama_tokenize(vocab, prompt.c_str(),
        static_cast<int>(prompt.size()), tokens.data(),
        static_cast<int>(tokens.size()), /*add_bos=*/true, /*special=*/true);
    if (n_tokens < 0) {
        PHC_LOGE("phc_stream_start: tokenization failed");
        return -2;
    }
    tokens.resize(n_tokens);
    g_stream_prompt_n = n_tokens;
    PHC_LOGI("phc_stream_start: prompt %d tokens (n_ctx=%d)", n_tokens, n_ctx);

    llama_memory_clear(llama_get_memory(ctx), true);

    const int n_batch_sz = (int) llama_n_batch(ctx);
    for (int i = 0; i < n_tokens; i += n_batch_sz) {
        int chunk = n_tokens - i;
        if (chunk > n_batch_sz) chunk = n_batch_sz;
        llama_batch batch = llama_batch_get_one(tokens.data() + i, chunk);
        if (llama_decode(ctx, batch) != 0) {
            PHC_LOGE("phc_stream_start: prompt decode failed at %d", i);
            return -3;
        }
    }

    llama_sampler_chain_params sparams = llama_sampler_chain_default_params();
    g_sampler = llama_sampler_chain_init(sparams);
    llama_sampler_chain_add(g_sampler, llama_sampler_init_penalties(
        /*penalty_last_n=*/64, /*penalty_repeat=*/repeat_penalty,
        /*penalty_freq=*/0.0f, /*penalty_present=*/0.0f));
    llama_sampler_chain_add(g_sampler, llama_sampler_init_top_p(top_p, 1));
    llama_sampler_chain_add(g_sampler, llama_sampler_init_temp(temperature));
    llama_sampler_chain_add(g_sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

    g_stream_eos = llama_vocab_eos(vocab);
    g_stream_eot = llama_vocab_eot(vocab);
    PHC_LOGI("phc_stream_start: ready");
    return 0;
}

/// Produce the next token's text. Returns a heap string (free via
/// phc_free_string) for each token, or nullptr when generation is finished
/// (EOS/EOT, token limit, context full, or decode error).
PHC_EXPORT const char* phc_stream_next(
    llama_context* ctx,
    llama_model* model,
    int max_tokens
) {
    if (!g_sampler || !ctx || !model) return nullptr;
    if (g_stream_cancel) return nullptr; // aborted by the user (barge-in / stop)

    const int n_ctx_max = (int) llama_n_ctx(ctx);
    if (g_stream_generated >= max_tokens ||
        (g_stream_prompt_n + g_stream_generated) >= n_ctx_max) {
        return nullptr;
    }

    const llama_vocab* vocab = llama_model_get_vocab(model);
    llama_token new_token = llama_sampler_sample(g_sampler, ctx, -1);
    if (new_token == g_stream_eos || new_token == g_stream_eot) {
        return nullptr;
    }

    // special=false so control tokens (<start_of_turn> etc.) don't leak as text.
    char piece[256];
    int piece_len = llama_token_to_piece(vocab, new_token, piece,
                                         sizeof(piece), 0, false);
    std::string s;
    if (piece_len > 0) s.assign(piece, piece_len);

    // Decode the sampled token so the next sample() sees updated logits.
    llama_batch next_batch = llama_batch_get_one(&new_token, 1);
    if (llama_decode(ctx, next_batch) != 0) {
        PHC_LOGE("phc_stream_next: decode failed at %d", g_stream_generated);
        return nullptr;
    }
    g_stream_generated++;

    // Empty piece (rare, e.g. some special tokens) -> return "" and keep going.
    return strdup(s.c_str());
}

/// Free the sampler after a stream ends or is aborted.
PHC_EXPORT void phc_stream_finish() {
    if (g_sampler) { llama_sampler_free(g_sampler); g_sampler = nullptr; }
    PHC_LOGI("phc_stream_finish: generated %d tokens", g_stream_generated);
}

/// Abort an in-flight generation (barge-in / stop). The worker's phc_stream_next
/// loop returns nullptr on its next iteration, ending generation promptly.
PHC_EXPORT void phc_stream_cancel() {
    g_stream_cancel = true;
    PHC_LOGI("phc_stream_cancel: requested");
}

/*
 * phc_free_string
 * Must be called by Dart FFI to free strings returned by phc_generate_response
 */
PHC_EXPORT void phc_free_string(const char* str) {
    if (str) {
        free(const_cast<char*>(str));
    }
}

/*
 * phc_get_version
 * Returns llama.cpp build info for diagnostics
 */
PHC_EXPORT const char* phc_get_version() {
    return strdup(llama_print_system_info());
}

#ifdef __cplusplus
}
#endif
