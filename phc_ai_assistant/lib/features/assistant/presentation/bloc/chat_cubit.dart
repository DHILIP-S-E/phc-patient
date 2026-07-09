// ============================================================
// PHC AI Assistant - Chat Cubit
// A SEPARATE, text-only chat brain used exclusively by the Chat screen.
// It is independent from the voice AssistantBloc — its own conversation, no STT,
// no TTS, no avatar. It shares only the underlying loaded model (via AiRepository
// singleton) so the ~800MB GGUF isn't loaded twice, and it NEVER unloads that
// model on close (the voice screen owns the model lifecycle).
// ============================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../ai_engine/domain/repositories/ai_repository.dart';

class ChatMessage extends Equatable {
  final String role; // 'user' | 'assistant'
  final String content;
  const ChatMessage({required this.role, required this.content});

  Map<String, String> toContextMap() => {'role': role, 'content': content};

  @override
  List<Object?> get props => [role, content];
}

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isGenerating;
  final String? error;
  final String languageCode;

  const ChatState({
    this.messages = const [],
    this.isGenerating = false,
    this.error,
    this.languageCode = 'en',
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
    String? error,
    String? languageCode,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [messages, isGenerating, error, languageCode];
}

class ChatCubit extends Cubit<ChatState> {
  final AiRepository _ai;
  final Logger _logger = Logger();

  ChatCubit(this._ai, {String languageCode = 'en'})
      : super(ChatState(languageCode: languageCode));

  void setLanguage(String code) => emit(state.copyWith(languageCode: code));

  void clear() => emit(state.copyWith(messages: const [], error: null));

  /// Stop an in-flight reply. The native generation aborts, the stream ends, and
  /// send()'s loop exits and clears the busy flag.
  void cancel() {
    if (!state.isGenerating) return;
    _ai.cancelGeneration();
    _logger.i('[ChatCubit] cancel requested');
  }

  /// Send a typed message and stream the reply token-by-token into the last
  /// assistant bubble. Text-only: no speaking.
  Future<void> send(String text) async {
    final t = text.trim();
    if (t.isEmpty || state.isGenerating) return;

    final base = [...state.messages, ChatMessage(role: 'user', content: t)];
    emit(state.copyWith(messages: base, isGenerating: true, error: null));

    _logger.i('[ChatCubit] ⤴ SENT at ${DateTime.now().toIso8601String()}: "$t"');
    final sw = Stopwatch()..start();

    String finalText = '';
    String? failure;

    await for (final either in _ai.generateResponseStream(
      userMessage: t,
      languageCode: state.languageCode,
      conversationHistory: base.map((m) => m.toContextMap()).toList(),
    )) {
      either.fold(
        (f) => failure = f.message,
        (partial) {
          finalText = partial;
          emit(state.copyWith(
            messages: [...base, ChatMessage(role: 'assistant', content: partial)],
          ));
        },
      );
    }

    sw.stop();
    if (failure != null) {
      _logger.e('[ChatCubit] ⤵ ERROR after ${sw.elapsedMilliseconds}ms: $failure');
      emit(state.copyWith(isGenerating: false, error: failure));
    } else {
      _logger.i('[ChatCubit] ⤵ DONE in ${sw.elapsedMilliseconds}ms: "$finalText"');
      emit(state.copyWith(isGenerating: false));
    }
  }

  // NOTE: deliberately no model unload in close() — the model belongs to the
  // voice screen's lifecycle. Closing the chat must not free RAM the voice
  // assistant is still using.
}
