// ============================================================
// PHC AI Assistant - Assistant BLoC
// Orchestrates the full voice AI pipeline
// User Voice → STT → Gemma → TTS → Avatar → Output
// ============================================================

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../features/ai_engine/domain/repositories/ai_repository.dart';
import '../../../../features/voice/data/datasources/speech_recognizer.dart';
import '../../../../features/voice/data/datasources/text_to_speech_datasource.dart';
import '../../../../features/voice/data/datasources/tts_playback_queue.dart';
import '../../../../features/voice/data/datasources/voice_setup_channel.dart';
import '../../../../features/avatar/controllers/avatar_controller.dart';
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final AiRepository _aiRepository;
  final SpeechRecognizer _sttSource;
  final TextToSpeechDataSource _ttsSource;
  final TtsPlaybackQueue _ttsQueue;
  final AvatarController _avatarController;
  final VoiceSetupChannel _voiceSetup;
  final Logger _logger = Logger();

  StreamSubscription<String>? _partialSub;
  StreamSubscription<String>? _finalSub;
  StreamSubscription<String>? _errorSub;
  StreamSubscription<double>? _downloadSub;

  Timer? _checkmarkTimer;

  // Which packs the currently-selected language is missing.
  bool _needTtsInstall = false;
  bool _needSttInstall = false;

  // Generation guard — prevents two concurrent generate calls.
  bool _generationCancelled = false;
  bool _isGenerating = false;

  AssistantBloc({
    required AiRepository aiRepository,
    required SpeechRecognizer sttSource,
    required TextToSpeechDataSource ttsSource,
    required TtsPlaybackQueue ttsQueue,
    required AvatarController avatarController,
    required VoiceSetupChannel voiceSetup,
  })  : _aiRepository = aiRepository,
        _sttSource = sttSource,
        _ttsSource = ttsSource,
        _ttsQueue = ttsQueue,
        _avatarController = avatarController,
        _voiceSetup = voiceSetup,
        super(const AssistantState.initial()) {
    on<InitializeAssistantEvent>(_onInitialize);
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<SpeechPartialEvent>(_onSpeechPartial);
    on<SpeechFinalEvent>(_onSpeechFinal);
    on<GenerateResponseEvent>(_onGenerateResponse);
    on<SpeakResponseEvent>(_onSpeakResponse);
    on<SpeakingCompleteEvent>(_onSpeakingComplete);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ClearConversationEvent>(_onClearConversation);
    on<StopSpeakingEvent>(_onStopSpeaking);
    on<InstallVoicePacksEvent>(_onInstallVoicePacks);
    on<SpeechErrorEvent>(_onSpeechError);
    on<SttDownloadProgressEvent>(_onSttDownloadProgress);
    on<CancelGenerationEvent>(_onCancelGeneration);
    on<ShowCheckmarkEvent>(_onShowCheckmark);
  }

  // ── Utility ───────────────────────────────────────────────

  void _onShowCheckmark(
    ShowCheckmarkEvent event,
    Emitter<AssistantState> emit,
  ) {
    if (state.phase == AssistantPhase.listening) {
      emit(state.copyWith(showCheckmark: true));
    }
  }

  void _onSttDownloadProgress(
    SttDownloadProgressEvent event,
    Emitter<AssistantState> emit,
  ) {
    emit(state.copyWith(sttDownloadProgress: event.progress));
  }

  // ── Cancel / Stop ─────────────────────────────────────────

  Future<void> _onCancelGeneration(
    CancelGenerationEvent event,
    Emitter<AssistantState> emit,
  ) async {
    _generationCancelled = true;
    _isGenerating = false;
    _checkmarkTimer?.cancel();
    _aiRepository.cancelGeneration();
    await _ttsQueue.clear();
    await _sttSource.stopListening();
    _avatarController.setIdle();
    emit(state.copyWith(phase: AssistantPhase.idle, showCheckmark: false));
  }

  Future<void> _onStopSpeaking(
    StopSpeakingEvent event,
    Emitter<AssistantState> emit,
  ) async {
    await _ttsQueue.clear();
    await _sttSource.stopListening();
    _avatarController.stopSpeaking();
    _avatarController.setIdle();
    emit(state.copyWith(phase: AssistantPhase.idle));
  }

  // ── Initialize ────────────────────────────────────────────

  Future<void> _onInitialize(
    InitializeAssistantEvent event,
    Emitter<AssistantState> emit,
  ) async {
    emit(state.copyWith(phase: AssistantPhase.initializing));

    try {
      // Initialize STT
      await _sttSource.initialize();

      // Initialize TTS
      await _ttsSource.initialize();
      await _ttsSource.configure(
        speechRate: 0.85,
        pitch: 1.0,
        volume: 1.0,
      );

      // Wire TTS callbacks → BLoC events.
      // IMPORTANT: We only wire onSpeakingChanged(false) to SpeakingCompleteEvent.
      // The TtsPlaybackQueue isSpeaking guard handles mid-queue silence windows.
      _ttsSource.onSpeakingChanged = (isSpeaking) {
        if (isSpeaking) {
          _avatarController.setSpeaking();
        } else {
          add(const SpeakingCompleteEvent());
        }
      };
      // onComplete fires after the very last sentence — belt + suspenders.
      _ttsSource.onComplete = () => add(const SpeakingCompleteEvent());

      // Wire STT streams → BLoC events.
      _partialSub = _sttSource.partialResults.listen(
        (text) => add(SpeechPartialEvent(text)),
      );
      _finalSub = _sttSource.finalResults.listen(
        (text) {
          if (text.isNotEmpty) add(SpeechFinalEvent(text));
        },
      );
      _errorSub = _sttSource.errors.listen(
        (errId) => add(SpeechErrorEvent(errId)),
      );
      _downloadSub = _sttSource.modelDownloadProgress.listen(
        (p) => add(SttDownloadProgressEvent(p)),
      );
    } catch (e) {
      _logger.e('[AssistantBloc] Voice hardware init failed: $e');
      emit(state.copyWith(
        phase: AssistantPhase.error,
        errorMessage: 'Failed to initialize voice services. Please check permissions.',
      ));
      return;
    }

    // Load AI model
    final loadResult = await _aiRepository.loadModel();
    final modelLoaded = loadResult.isRight();

    if (!modelLoaded) {
      emit(state.copyWith(
        phase: AssistantPhase.error,
        errorMessage: 'Failed to load AI model.',
        isModelLoaded: false,
      ));
      return;
    }

    // Greet user
    _avatarController.setGreeting();
    emit(state.copyWith(
      phase: AssistantPhase.idle,
      isModelLoaded: true,
    ));

    // Speak greeting, then loop starts automatically.
    final greeting = _getGreeting(state.languageCode);
    add(SpeakResponseEvent(greeting));
  }

  // ── Listening ─────────────────────────────────────────────

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<AssistantState> emit,
  ) async {
    // Barge-in: if the model is mid-reply, stop it.
    if (state.phase == AssistantPhase.processing) {
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
    }
    if (state.phase == AssistantPhase.speaking) {
      await _ttsQueue.clear();
    }

    _avatarController.setListening();
    _checkmarkTimer?.cancel();

    // Show manual submit checkmark if user speaks for >5 seconds.
    _checkmarkTimer = Timer(const Duration(seconds: 5), () {
      if (state.phase == AssistantPhase.listening) {
        add(const ShowCheckmarkEvent());
      }
    });

    emit(state.copyWith(
      phase: AssistantPhase.listening,
      partialSpeechText: '',
      showCheckmark: false,
    ));

    try {
      // background:false = this is the active listening session.
      await _sttSource.startListening(background: false);
    } catch (e) {
      _logger.e('[AssistantBloc] STT start error: $e');
      _avatarController.setIdle();
      emit(state.copyWith(
        phase: AssistantPhase.error,
        errorMessage: 'Microphone error. Please check permissions.',
      ));
    }
  }

  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<AssistantState> emit,
  ) async {
    _checkmarkTimer?.cancel();
    await _sttSource.stopListening();
    if (state.phase == AssistantPhase.listening) {
      _avatarController.setIdle();
      emit(state.copyWith(phase: AssistantPhase.idle, showCheckmark: false));
    }
  }

  // ── Speech partial (live transcript) ─────────────────────

  void _onSpeechPartial(
    SpeechPartialEvent event,
    Emitter<AssistantState> emit,
  ) {
    // Barge-in: user spoke actual words while model was processing/speaking.
    if (event.text.isNotEmpty &&
        (state.phase == AssistantPhase.processing ||
         state.phase == AssistantPhase.speaking)) {
      _logger.i('[AssistantBloc] Barge-in partial: "${event.text}"');
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
      _ttsQueue.clear();
      _avatarController.setListening();

      _checkmarkTimer?.cancel();
      _checkmarkTimer = Timer(const Duration(seconds: 5), () {
        if (state.phase == AssistantPhase.listening) {
          add(const ShowCheckmarkEvent());
        }
      });

      emit(state.copyWith(
        phase: AssistantPhase.listening,
        partialSpeechText: event.text,
        showCheckmark: false,
      ));
      return;
    }

    // Normal live transcript update during listening phase.
    if (state.phase != AssistantPhase.listening) return;

    final bool shouldShowCheckmark = state.showCheckmark || event.text.length > 60;
    emit(state.copyWith(
      partialSpeechText: event.text,
      showCheckmark: shouldShowCheckmark,
    ));
  }

  // ── Speech final ─────────────────────────────────────────

  Future<void> _onSpeechFinal(
    SpeechFinalEvent event,
    Emitter<AssistantState> emit,
  ) async {
    _logger.i('[AssistantBloc] Final speech: "${event.text}"');
    _checkmarkTimer?.cancel();

    if (event.text.isEmpty) return;

    // Barge-in: user finished speaking while model was processing/speaking.
    if (state.phase == AssistantPhase.processing ||
        state.phase == AssistantPhase.speaking) {
      _logger.i('[AssistantBloc] Barge-in final: "${event.text}"');
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
      await _ttsQueue.clear();
    }

    // Immediately show "Thinking..." so the user gets instant feedback.
    _avatarController.setThinking();
    emit(state.copyWith(
      phase: AssistantPhase.processing,
      partialSpeechText: event.text,
      showCheckmark: false,
    ));

    // Fire generation — GenerateResponseEvent will update conversation list.
    add(GenerateResponseEvent(event.text));
  }

  // ── Generate AI Response ──────────────────────────────────

  Future<void> _onGenerateResponse(
    GenerateResponseEvent event,
    Emitter<AssistantState> emit,
  ) async {
    // Guard: prevent two concurrent generations.
    if (_isGenerating) {
      _logger.w('[AssistantBloc] Busy generating; ignoring duplicate.');
      return;
    }
    _isGenerating = true;
    _generationCancelled = false;

    final userMsg = ConversationMessage(
      role: 'user',
      content: event.userMessage,
      timestamp: DateTime.now(),
    );
    final baseConversation = [...state.conversation, userMsg];

    // Update conversation list (phase already set to processing in _onSpeechFinal).
    emit(state.copyWith(
      conversation: baseConversation,
      currentSubtitle: '',
    ));

    final sw = Stopwatch()..start();
    _logger.i('[AssistantBloc] ⤴ Generating for: "${event.userMessage}"');

    String finalText = '';
    Failure? failure;
    int lastSpokenIndex = 0;

    if (event.speak) {
      await _ttsSource.setLanguage(state.languageCode);
    }

    // Stream tokens live.
    await emit.onEach<Either<Failure, String>>(
      _aiRepository.generateResponseStream(
        userMessage: event.userMessage,
        languageCode: state.languageCode,
        conversationHistory:
            baseConversation.map((m) => m.toContextMap()).toList(),
      ),
      onData: (either) {
        either.fold(
          (f) => failure = f,
          (partial) {
            finalText = partial;

            // Sentence-by-sentence TTS streaming.
            if (event.speak && partial.length > lastSpokenIndex) {
              final newText = partial.substring(lastSpokenIndex);
              final matches = RegExp(r'[.?!;\n]+').allMatches(newText);
              if (matches.isNotEmpty) {
                final sentenceEnd = matches.last.end;
                final sentenceToSpeak = newText.substring(0, sentenceEnd).trim();
                if (sentenceToSpeak.isNotEmpty && !_generationCancelled) {
                  if (state.phase != AssistantPhase.speaking) {
                    emit(state.copyWith(phase: AssistantPhase.speaking));
                    // Start BACKGROUND listening for barge-in.
                    _sttSource.startListening(background: true).catchError((e) {
                      _logger.e('[AssistantBloc] Background STT failed: $e');
                    });
                  }
                  _ttsQueue.enqueue(sentenceToSpeak);
                  lastSpokenIndex += sentenceEnd;
                }
              }
            }

            // Update live subtitle.
            final assistantMsg = ConversationMessage(
              role: 'assistant',
              content: partial,
              timestamp: DateTime.now(),
            );
            emit(state.copyWith(
              conversation: [...baseConversation, assistantMsg],
              currentSubtitle: partial,
            ));
          },
        );
      },
    );

    sw.stop();
    _logger.i('[AssistantBloc] ⤵ Done in ${sw.elapsedMilliseconds}ms');

    if (_generationCancelled) {
      _generationCancelled = false;
      _isGenerating = false;
      _logger.i('[AssistantBloc] Generation was cancelled.');
      return;
    }

    if (failure != null) {
      _logger.e('[AssistantBloc] Generation error: ${failure!.message}');
      _avatarController.setIdle();
      _isGenerating = false;
      emit(state.copyWith(
        phase: AssistantPhase.error,
        errorMessage: failure!.message,
      ));
      return;
    }

    if (finalText.trim().isEmpty) {
      _avatarController.setIdle();
      _isGenerating = false;
      emit(state.copyWith(phase: AssistantPhase.idle));
      return;
    }

    // Enqueue remainder (last phrase without trailing punctuation).
    if (event.speak && lastSpokenIndex < finalText.length) {
      final remainder = finalText.substring(lastSpokenIndex).trim();
      if (remainder.isNotEmpty && !_generationCancelled) {
        if (state.phase != AssistantPhase.speaking) {
          emit(state.copyWith(phase: AssistantPhase.speaking));
          _sttSource.startListening(background: true).catchError((e) {
            _logger.e('[AssistantBloc] Background STT failed: $e');
          });
        }
        _ttsQueue.enqueue(remainder);
      }
    }

    if (!event.speak) {
      _avatarController.setIdle();
      _isGenerating = false;
      emit(state.copyWith(phase: AssistantPhase.idle));
    } else {
      _isGenerating = false;
    }
  }

  // ── Speak direct text ─────────────────────────────────────

  Future<void> _onSpeakResponse(
    SpeakResponseEvent event,
    Emitter<AssistantState> emit,
  ) async {
    emit(state.copyWith(
      phase: AssistantPhase.speaking,
      currentSubtitle: event.text,
    ));
    await _ttsSource.setLanguage(state.languageCode);
    _ttsQueue.enqueue(event.text);

    // Start background listening for barge-in during greeting/direct speech.
    try {
      await _sttSource.startListening(background: true);
    } catch (e) {
      _logger.e('[AssistantBloc] Background STT failed: $e');
    }
  }

  // ── Speaking complete → restart loop ──────────────────────

  void _onSpeakingComplete(
    SpeakingCompleteEvent event,
    Emitter<AssistantState> emit,
  ) {
    // Only act if we are in speaking phase.
    if (state.phase != AssistantPhase.speaking) return;

    // If the queue still has sentences or TTS is still playing, do nothing.
    // The queue's isSpeaking has no gap between sentences (fixed in TtsPlaybackQueue).
    if (_ttsQueue.isSpeaking) {
      _logger.d('[AssistantBloc] SpeakingComplete but queue still active — waiting.');
      return;
    }

    _logger.i('[AssistantBloc] All speech done — restarting listening.');
    _avatarController.stopSpeaking();
    _avatarController.setIdle();
    emit(state.copyWith(phase: AssistantPhase.idle));

    // 🔑 Continuous conversational loop.
    add(const StartListeningEvent());
  }

  // ── Language ──────────────────────────────────────────────

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<AssistantState> emit,
  ) async {
    _sttSource.setLanguage(event.languageCode);
    await _ttsSource.setLanguage(event.languageCode);

    final ttsOk = await _ttsSource.isLanguageAvailable(event.languageCode);
    final sttOk = await _sttSource.isLanguageAvailable(event.languageCode);
    _needTtsInstall = !ttsOk;
    _needSttInstall = !sttOk;

    String? prompt;
    if (!ttsOk || !sttOk) {
      final name = LanguageConstants.getLanguage(event.languageCode).name;
      final missing = <String>[];
      if (!sttOk) missing.add('speech input');
      if (!ttsOk) missing.add('voice');
      prompt = '$name ${missing.join(' & ')} not installed on this phone.';
      _logger.w('[AssistantBloc] $prompt (offer install)');
    }

    emit(state.copyWith(
      languageCode: event.languageCode,
      voicePackPrompt: prompt,
    ));
  }

  Future<void> _onInstallVoicePacks(
    InstallVoicePacksEvent event,
    Emitter<AssistantState> emit,
  ) async {
    if (_needSttInstall) {
      await _voiceSetup.openVoiceInputSettings();
    } else if (_needTtsInstall) {
      await _voiceSetup.installTtsData();
    }
    emit(state.copyWith(voicePackPrompt: null));
  }

  // ── Speech errors ─────────────────────────────────────────

  Future<void> _onSpeechError(
    SpeechErrorEvent event,
    Emitter<AssistantState> emit,
  ) async {
    final isTransient = event.errorId.contains('no_match') ||
                        event.errorId.contains('speech_timeout') ||
                        event.errorId.contains('recognizer_busy');

    _logger.d('[AssistantBloc] SpeechError: ${event.errorId} transient:$isTransient phase:${state.phase}');

    // Errors during AI speaking/processing phases are from the background
    // barge-in session. Silently restart the background listener.
    if (state.phase == AssistantPhase.speaking ||
        state.phase == AssistantPhase.processing) {
      _logger.d('[AssistantBloc] Ignoring speech error during ${state.phase}');
      return;
    }

    // During listening: transient errors (silence / no words) should silently
    // restart the loop. Non-transient errors (permission denied etc.) show UI.
    if (isTransient) {
      _logger.d('[AssistantBloc] Transient error — restarting listening.');
      _avatarController.setIdle();
      emit(state.copyWith(phase: AssistantPhase.idle, showCheckmark: false));
      add(const StartListeningEvent());
    } else {
      _avatarController.setIdle();
      if (state.phase == AssistantPhase.listening ||
          state.phase == AssistantPhase.idle) {
        emit(state.copyWith(
          phase: AssistantPhase.idle,
          errorMessage: 'Microphone error (${event.errorId}). Please try again.',
          showCheckmark: false,
        ));
      }
    }
  }

  // ── Conversation ──────────────────────────────────────────

  Future<void> _onClearConversation(
    ClearConversationEvent event,
    Emitter<AssistantState> emit,
  ) async {
    await _aiRepository.clearContext();
    emit(state.copyWith(
      conversation: [],
      currentSubtitle: '',
    ));
  }

  // ── Greetings ─────────────────────────────────────────────

  String _getGreeting(String langCode) {
    const greetings = {
      'en': 'Hello! I am Aarogya, your healthcare assistant. How are you feeling today?',
      'hi': 'नमस्ते! मैं आरोग्य हूं, आपका स्वास्थ्य सहायक। आज आप कैसा महसूस कर रहे हैं?',
      'ta': 'வணக்கம்! நான் ஆரோக்யா, உங்கள் சுகாதார உதவியாளர். இன்று எப்படி உணர்கிறீர்கள்?',
      'te': 'నమస్కారం! నేను ఆరోగ్య, మీ ఆరోగ్య సహాయకుడిని. ఈరోజు మీరు ఎలా అనుభవిస్తున్నారు?',
      'ml': 'നമസ്കാരം! ഞാൻ ആരോഗ്യ, നിങ്ങളുടെ ആരോഗ്യ സഹായി. ഇന്ന് നിങ്ങൾക്ക് എങ്ങനെ തോന്നുന്നു?',
      'kn': 'ನಮಸ್ಕಾರ! ನಾನು आरोग्य, ನಿಮ್ಮ ಆರೋಗ್ಯ ಸಹಾಯಕ. ಇಂದು ನೀವು ಹೇಗೆ ಅನುಭವಿಸುತ್ತಿದ್ದೀರಿ?',
      'bn': 'নমস্কার! আমি আরোগ্য, আপনার স্বাস্থ্য সহকারী। আজ আপনি কেমন অনুভব করছেন?',
      'gu': 'નમસ્તે! હું આરોગ્ય, તમારો આરોગ્ય સહાયક. આજે તમને કેવું લાગે છે?',
      'mr': 'नमस्कार! मी आरोग्य, तुमचा आरोग्य सहाय्यक. आज तुम्हाला कसे वाटत आहे?',
    };
    return greetings[langCode] ?? greetings['en']!;
  }

  @override
  Future<void> close() async {
    _checkmarkTimer?.cancel();
    await _partialSub?.cancel();
    await _finalSub?.cancel();
    await _errorSub?.cancel();
    await _downloadSub?.cancel();
    await _aiRepository.unloadModel();
    return super.close();
  }
}
