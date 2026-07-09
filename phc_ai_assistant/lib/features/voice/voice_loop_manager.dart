// ============================================================
// PHC AI Assistant - Voice Loop Manager
// ============================================================

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:phc_ai_assistant/core/constants/language_constants.dart';
import 'package:phc_ai_assistant/core/errors/failures.dart';
import 'package:phc_ai_assistant/core/ai/ai_repository.dart';
import 'package:phc_ai_assistant/core/speech/speech_recognizer.dart';
import 'package:phc_ai_assistant/core/tts/text_to_speech_datasource.dart';
import 'package:phc_ai_assistant/core/tts/tts_playback_queue.dart';
import 'package:phc_ai_assistant/core/speech/voice_setup_channel.dart';
import 'package:phc_ai_assistant/shared/widgets/avatar/controllers/avatar_controller.dart';
import 'voice_loop_state.dart';

class VoiceLoopManager extends Cubit<VoiceLoopState> {
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
  bool _needTtsInstall = false;
  bool _needSttInstall = false;
  bool _generationCancelled = false;
  bool _isGenerating = false;

  VoiceLoopManager({
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
        super(const VoiceLoopState.initial());

  // ── Initialize ────────────────────────────────────────────
  Future<void> initialize() async {
    emit(state.copyWith(phase: VoiceLoopPhase.initializing));

    try {
      await _sttSource.initialize();
      await _ttsSource.initialize();
      await _ttsSource.configure(
        speechRate: 0.85,
        pitch: 1.0,
        volume: 1.0,
      );

      _ttsSource.onSpeakingChanged = (isSpeaking) {
        if (isSpeaking) {
          _avatarController.setSpeaking();
        } else {
          _onSpeakingChanged(false);
        }
      };
      _ttsSource.onComplete = () => _onSpeakingChanged(false);

      _partialSub = _sttSource.partialResults.listen(_onSpeechPartial);
      _finalSub = _sttSource.finalResults.listen(_onSpeechFinal);
      _errorSub = _sttSource.errors.listen(_onSpeechError);
      _downloadSub = _sttSource.modelDownloadProgress.listen(_onSttDownloadProgress);
    } catch (e) {
      _logger.e('[VoiceLoop] Init failed: $e');
      emit(state.copyWith(
        phase: VoiceLoopPhase.error,
        errorMessage: 'Failed to initialize voice services. Please check permissions.',
      ));
      return;
    }

    final loadResult = await _aiRepository.loadModel();
    final modelLoaded = loadResult.isRight();

    if (!modelLoaded) {
      emit(state.copyWith(
        phase: VoiceLoopPhase.error,
        errorMessage: 'Failed to load AI model.',
        isModelLoaded: false,
      ));
      return;
    }

    _avatarController.setGreeting();
    emit(state.copyWith(
      phase: VoiceLoopPhase.idle,
      isModelLoaded: true,
    ));

    final greeting = _getGreeting(state.languageCode);
    await speakResponse(greeting);
  }

  // ── Start/Stop Listening ──────────────────────────────────
  Future<void> startListening() async {
    if (state.phase == VoiceLoopPhase.thinking) {
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
    }
    if (state.phase == VoiceLoopPhase.speaking) {
      await _ttsQueue.clear();
    }

    _avatarController.setListening();
    _checkmarkTimer?.cancel();

    _checkmarkTimer = Timer(const Duration(seconds: 5), () {
      if (state.phase == VoiceLoopPhase.listening) {
        emit(state.copyWith(showCheckmark: true));
      }
    });

    emit(state.copyWith(
      phase: VoiceLoopPhase.listening,
      partialSpeechText: '',
      showCheckmark: false,
    ));

    try {
      await _sttSource.startListening(background: false);
    } catch (e) {
      _logger.e('[VoiceLoop] STT start failed: $e');
      _avatarController.setIdle();
      emit(state.copyWith(
        phase: VoiceLoopPhase.error,
        errorMessage: 'Microphone error. Please check permissions.',
      ));
    }
  }

  Future<void> stopListening() async {
    _checkmarkTimer?.cancel();
    await _sttSource.stopListening();
    if (state.phase == VoiceLoopPhase.listening) {
      _avatarController.setIdle();
      emit(state.copyWith(phase: VoiceLoopPhase.idle, showCheckmark: false));
    }
  }

  Future<void> cancelListening() async {
    _checkmarkTimer?.cancel();
    await _sttSource.stopListening();
    _avatarController.setIdle();
    emit(state.copyWith(phase: VoiceLoopPhase.idle, showCheckmark: false));
  }

  // ── Speech Events Handlers ────────────────────────────────
  void _onSpeechPartial(String text) {
    if (text.isNotEmpty &&
        (state.phase == VoiceLoopPhase.thinking ||
         state.phase == VoiceLoopPhase.speaking)) {
      _logger.i('[VoiceLoop] Barge-in detected (partial): "$text"');
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
      _ttsQueue.clear();
      _avatarController.setListening();

      _checkmarkTimer?.cancel();
      _checkmarkTimer = Timer(const Duration(seconds: 5), () {
        if (state.phase == VoiceLoopPhase.listening) {
          emit(state.copyWith(showCheckmark: true));
        }
      });

      emit(state.copyWith(
        phase: VoiceLoopPhase.listening,
        partialSpeechText: text,
        showCheckmark: false,
      ));
      return;
    }

    if (state.phase != VoiceLoopPhase.listening) return;

    final bool shouldShowCheckmark = state.showCheckmark || text.length > 60;
    emit(state.copyWith(
      partialSpeechText: text,
      showCheckmark: shouldShowCheckmark,
    ));
  }

  void _onSpeechFinal(String text) {
    _logger.i('[VoiceLoop] Final speech: "$text"');
    _checkmarkTimer?.cancel();

    if (text.isEmpty) return;

    if (state.phase == VoiceLoopPhase.thinking ||
        state.phase == VoiceLoopPhase.speaking) {
      _logger.i('[VoiceLoop] Barge-in detected (final): "$text"');
      _generationCancelled = true;
      _isGenerating = false;
      _aiRepository.cancelGeneration();
      _ttsQueue.clear();
    }

    _avatarController.setThinking();
    emit(state.copyWith(
      phase: VoiceLoopPhase.thinking,
      partialSpeechText: text,
      showCheckmark: false,
    ));

    _generateResponse(text);
  }

  void _onSpeechError(String errorId) {
    final isTransient = errorId.contains('no_match') ||
                        errorId.contains('speech_timeout') ||
                        errorId.contains('recognizer_busy');

    _logger.d('[VoiceLoop] SpeechError: $errorId transient:$isTransient phase:${state.phase}');

    if (state.phase == VoiceLoopPhase.speaking ||
        state.phase == VoiceLoopPhase.thinking) {
      _logger.d('[VoiceLoop] Ignoring speech error during ${state.phase}');
      return;
    }

    if (isTransient) {
      _logger.d('[VoiceLoop] Transient error - restarting listening.');
      _avatarController.setIdle();
      emit(state.copyWith(phase: VoiceLoopPhase.idle, showCheckmark: false));
      startListening();
    } else {
      _avatarController.setIdle();
      if (state.phase == VoiceLoopPhase.listening ||
          state.phase == VoiceLoopPhase.idle) {
        emit(state.copyWith(
          phase: VoiceLoopPhase.idle,
          errorMessage: 'Microphone error ($errorId). Please try again.',
          showCheckmark: false,
        ));
      }
    }
  }

  void _onSttDownloadProgress(double progress) {
    emit(state.copyWith(sttDownloadProgress: progress));
  }

  // ── AI Response Generation ────────────────────────────────
  Future<void> _generateResponse(String userMessage) async {
    if (_isGenerating) {
      _logger.w('[VoiceLoop] Busy generating; ignoring duplicate.');
      return;
    }
    _isGenerating = true;
    _generationCancelled = false;

    final userMsg = VoiceMessage(
      role: 'user',
      content: userMessage,
      timestamp: DateTime.now(),
    );
    final baseConversation = [...state.conversation, userMsg];

    emit(state.copyWith(
      conversation: baseConversation,
      currentSubtitle: '',
    ));

    final sw = Stopwatch()..start();
    _logger.i('[VoiceLoop] ⤴ Generating for: "$userMessage"');

    String finalText = '';
    Failure? failure;
    int lastSpokenIndex = 0;

    await _ttsSource.setLanguage(state.languageCode);

    final stream = _aiRepository.generateResponseStream(
      userMessage: userMessage,
      languageCode: state.languageCode,
      conversationHistory: baseConversation.map((m) => m.toContextMap()).toList(),
    );

    await for (final either in stream) {
      if (_generationCancelled) break;

      either.fold(
        (f) => failure = f,
        (partial) {
          finalText = partial;

          if (partial.length > lastSpokenIndex) {
            final newText = partial.substring(lastSpokenIndex);
            final matches = RegExp(r'[.?!;\n]+').allMatches(newText);
            if (matches.isNotEmpty) {
              final sentenceEnd = matches.last.end;
              final sentenceToSpeak = newText.substring(0, sentenceEnd).trim();
              if (sentenceToSpeak.isNotEmpty && !_generationCancelled) {
                if (state.phase != VoiceLoopPhase.speaking) {
                  emit(state.copyWith(phase: VoiceLoopPhase.speaking));
                  _sttSource.startListening(background: true).catchError((e) {
                    _logger.e('[VoiceLoop] Background STT failed: $e');
                  });
                }
                _ttsQueue.enqueue(sentenceToSpeak);
                lastSpokenIndex += sentenceEnd;
              }
            }
          }

          final assistantMsg = VoiceMessage(
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
    }

    sw.stop();
    _logger.i('[VoiceLoop] ⤵ Done in ${sw.elapsedMilliseconds}ms');

    if (_generationCancelled) {
      _generationCancelled = false;
      _isGenerating = false;
      _logger.i('[VoiceLoop] Generation cancelled.');
      return;
    }

    if (failure != null) {
      _logger.e('[VoiceLoop] Generation error: ${failure!.message}');
      _avatarController.setIdle();
      _isGenerating = false;
      emit(state.copyWith(
        phase: VoiceLoopPhase.error,
        errorMessage: failure!.message,
      ));
      return;
    }

    if (finalText.trim().isEmpty) {
      _avatarController.setIdle();
      _isGenerating = false;
      emit(state.copyWith(phase: VoiceLoopPhase.idle));
      return;
    }

    if (lastSpokenIndex < finalText.length) {
      final remainder = finalText.substring(lastSpokenIndex).trim();
      if (remainder.isNotEmpty && !_generationCancelled) {
        if (state.phase != VoiceLoopPhase.speaking) {
          emit(state.copyWith(phase: VoiceLoopPhase.speaking));
          _sttSource.startListening(background: true).catchError((e) {
            _logger.e('[VoiceLoop] Background STT failed: $e');
          });
        }
        _ttsQueue.enqueue(remainder);
      }
    }

    _isGenerating = false;
  }

  // ── TTS Callbacks ─────────────────────────────────────────
  void _onSpeakingChanged(bool isSpeaking) {
    if (!isSpeaking) {
      if (state.phase != VoiceLoopPhase.speaking) return;

      if (_ttsQueue.isSpeaking) {
        _logger.d('[VoiceLoop] Speaking completed but queue still active - waiting.');
        return;
      }

      _logger.i('[VoiceLoop] All speech completed - restarting loop.');
      _avatarController.stopSpeaking();
      _avatarController.setIdle();
      emit(state.copyWith(phase: VoiceLoopPhase.idle));
      startListening();
    }
  }

  // ── Speech Actions ────────────────────────────────────────
  Future<void> speakResponse(String text) async {
    emit(state.copyWith(
      phase: VoiceLoopPhase.speaking,
      currentSubtitle: text,
    ));
    await _ttsSource.setLanguage(state.languageCode);
    _ttsQueue.enqueue(text);

    try {
      await _sttSource.startListening(background: true);
    } catch (e) {
      _logger.e('[VoiceLoop] Background STT failed: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _ttsQueue.clear();
    await _sttSource.stopListening();
    _avatarController.stopSpeaking();
    _avatarController.setIdle();
    emit(state.copyWith(phase: VoiceLoopPhase.idle));
  }

  Future<void> cancelGeneration() async {
    _generationCancelled = true;
    _isGenerating = false;
    _checkmarkTimer?.cancel();
    _aiRepository.cancelGeneration();
    await _ttsQueue.clear();
    await _sttSource.stopListening();
    _avatarController.setIdle();
    emit(state.copyWith(phase: VoiceLoopPhase.idle, showCheckmark: false));
  }

  // ── Settings Actions ──────────────────────────────────────
  Future<void> changeLanguage(String languageCode) async {
    _sttSource.setLanguage(languageCode);
    await _ttsSource.setLanguage(languageCode);

    final ttsOk = await _ttsSource.isLanguageAvailable(languageCode);
    final sttOk = await _sttSource.isLanguageAvailable(languageCode);
    _needTtsInstall = !ttsOk;
    _needSttInstall = !sttOk;

    String? prompt;
    if (!ttsOk || !sttOk) {
      final name = LanguageConstants.getLanguage(languageCode).name;
      final missing = <String>[];
      if (!sttOk) missing.add('speech input');
      if (!ttsOk) missing.add('voice');
      prompt = '$name ${missing.join(' & ')} not installed on this phone.';
    }

    emit(state.copyWith(
      languageCode: languageCode,
      voicePackPrompt: prompt,
    ));
  }

  Future<void> installVoicePacks() async {
    if (_needSttInstall) {
      await _voiceSetup.openVoiceInputSettings();
    } else if (_needTtsInstall) {
      await _voiceSetup.installTtsData();
    }
    emit(state.copyWith(voicePackPrompt: null));
  }

  Future<void> clearConversation() async {
    await _aiRepository.clearContext();
    emit(state.copyWith(
      conversation: [],
      currentSubtitle: '',
    ));
  }

  String _getGreeting(String langCode) {
    const greetings = {
      'en': 'Hello! I am Aarogya, your healthcare assistant. How are you feeling today?',
      'hi': 'नमस्ते! मैं आरोग्य हूं, आपका स्वास्थ्य सहायक। आज आप कैसा महसूस कर रहे हैं?',
      'ta': 'வணக்கம்! நான் ஆரோக்யா, உங்கள் சுகாதார உதவியாளர். இன்று எப்படி உணர்கிறீர்கள்?',
      'te': 'నమస్కారం! నేను ఆరోగ్య, మీ ఆరోగ్య సహాయకుడిని. ఈరోజు మీరు ఎలా అనుభవిస్తున్నారు?',
      'ml': 'நமസ്കാരം! ഞാൻ ആരോഗ്യ, നിങ്ങളുടെ ആരോഗ്യ സഹായി. ഇന്ന് നിങ്ങൾക്ക് എങ്ങനെ തോന്നുന്നു?',
      'kn': 'ನಮಸ್ಕಾರ! ನಾನು आरोग्य, ನಿಮ್ಮ आरोग्य ಸಹಾಯಕ. ಇಂದು ನೀವು ಹೇಗೆ ಅನುಭವಿಸುತ್ತಿದ್ದೀರಿ?',
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
