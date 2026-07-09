// ============================================================
// PHC AI Assistant - Dependency Injection Container
// Uses GetIt for service locator pattern
// ============================================================

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/ai_engine/data/datasources/gemma_inference_datasource.dart';
import '../../features/ai_engine/data/repositories/ai_repository_impl.dart';
import '../../features/ai_engine/domain/repositories/ai_repository.dart';
import '../../features/avatar/controllers/avatar_controller.dart';
import '../../features/model_download/data/datasources/model_download_datasource.dart';
import '../../features/model_download/data/repositories/model_repository_impl.dart';
import '../../features/model_download/domain/repositories/model_repository.dart';
import '../../features/model_download/presentation/bloc/model_download_bloc.dart';
import '../../features/voice/data/datasources/speech_recognizer.dart';
import '../../features/voice/data/datasources/speech_to_text_datasource.dart';
import '../../features/voice/data/datasources/text_to_speech_datasource.dart';
import '../../features/voice/data/datasources/tts_playback_queue.dart';
import '../../features/voice/data/datasources/voice_setup_channel.dart';
import '../../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../../features/assistant/presentation/bloc/chat_cubit.dart';

// Separate GetIt instance (not GetIt.instance) so this doesn't collide with
// anything phc-patient registers on the default instance elsewhere.
final sl = GetIt.asNewInstance();

Future<void> configureDependencies() async {
  // Offline mode can be entered/exited repeatedly within one app session
  // (toggle back to Online, then back to Offline) — guard against
  // re-registering singletons on GetIt.
  if (sl.isRegistered<SharedPreferences>()) return;

  // ── External Dependencies ─────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Dio with interceptors for download
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 30),
    headers: {
      'Accept': '*/*',
      'User-Agent': 'PHC-AI-Assistant/1.0',
    },
  ));
  dio.interceptors.add(LogInterceptor(
    request: false,
    responseBody: false,
    requestBody: false,
  ));
  sl.registerSingleton<Dio>(dio);

  // ── Data Sources ──────────────────────────────────────────
  sl.registerSingleton<ModelDownloadDataSource>(
    ModelDownloadDataSource(
      dio: sl<Dio>(),
      prefs: sl<SharedPreferences>(),
    ),
  );

  sl.registerSingleton<GemmaInferenceDataSource>(
    GemmaInferenceDataSource(),
  );

  // See core/config/app_config.dart: system (Android recognizer) is the only
  // supported engine in this port — the whisper/hybrid fallback was dropped.
  sl.registerLazySingleton<SpeechRecognizer>(() => SpeechToTextDataSource());

  sl.registerLazySingleton<TextToSpeechDataSource>(
    () => TextToSpeechDataSource(),
  );

  sl.registerLazySingleton<TtsPlaybackQueue>(
    () => TtsPlaybackQueue(sl<TextToSpeechDataSource>()),
  );

  sl.registerLazySingleton<VoiceSetupChannel>(
    () => VoiceSetupChannel(),
  );

  // ── Repositories ──────────────────────────────────────────
  sl.registerSingleton<ModelRepository>(
    ModelRepositoryImpl(
      dataSource: sl<ModelDownloadDataSource>(),
      prefs: sl<SharedPreferences>(),
    ),
  );

  sl.registerSingleton<AiRepository>(
    AiRepositoryImpl(
      inferenceSource: sl<GemmaInferenceDataSource>(),
      prefs: sl<SharedPreferences>(),
    ),
  );

  // ── Avatar Controller ─────────────────────────────────────
  sl.registerLazySingleton<AvatarController>(() => AvatarController());

  // ── BLoCs ─────────────────────────────────────────────────
  sl.registerFactory<ModelDownloadBloc>(
    () => ModelDownloadBloc(repository: sl<ModelRepository>()),
  );

  sl.registerFactory<AssistantBloc>(
    () => AssistantBloc(
      aiRepository: sl<AiRepository>(),
      sttSource: sl<SpeechRecognizer>(),
      ttsSource: sl<TextToSpeechDataSource>(),
      ttsQueue: sl<TtsPlaybackQueue>(),
      avatarController: sl<AvatarController>(),
      voiceSetup: sl<VoiceSetupChannel>(),
    ),
  );

  // Chat is a SEPARATE brain from voice. It shares the loaded model (same
  // AiRepository singleton) but keeps its own conversation. The language is
  // passed in per-instance when the Chat screen is opened.
  sl.registerFactoryParam<ChatCubit, String, void>(
    (languageCode, _) =>
        ChatCubit(sl<AiRepository>(), languageCode: languageCode),
  );
}
