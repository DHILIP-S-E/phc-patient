// ============================================================
// PHC AI Assistant - Chat Cubit
// A SEPARATE, text-only chat brain used exclusively by the Chat screen.
// It is independent from the voice AssistantBloc — its own conversation, no STT,
// no TTS, no avatar. It shares only the underlying loaded model (via AiRepository
// singleton) so the ~800MB GGUF isn't loaded twice, and it NEVER unloads that
// model on close (the voice screen owns the model lifecycle).
// ============================================================

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phc_ai_assistant/core/ai/ai_repository.dart';

class ChatMessage extends Equatable {
  final String role; // 'user' | 'assistant'
  final String content;
  const ChatMessage({required this.role, required this.content});

  Map<String, String> toContextMap() => {'role': role, 'content': content};

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };

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
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  static const String _historyKey = 'chat_history';

  ChatCubit(this._ai, this._prefs, {String languageCode = 'en'})
      : super(ChatState(languageCode: languageCode)) {
    _loadHistory();
  }

  void _loadHistory() {
    try {
      final jsonStr = _prefs.getString(_historyKey);
      if (jsonStr != null) {
        final decoded = json.decode(jsonStr) as List<dynamic>;
        final messages = decoded
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(messages: messages));
        _logger.i('[ChatCubit] Loaded ${messages.length} messages from history');
      }
    } catch (e) {
      _logger.e('[ChatCubit] Error loading history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final list = state.messages.map((m) => m.toJson()).toList();
      final jsonStr = json.encode(list);
      await _prefs.setString(_historyKey, jsonStr);
      _logger.i('[ChatCubit] Saved ${state.messages.length} messages to history');
    } catch (e) {
      _logger.e('[ChatCubit] Error saving history: $e');
    }
  }

  void setLanguage(String code) => emit(state.copyWith(languageCode: code));

  void clear() {
    emit(state.copyWith(messages: const [], error: null));
    _saveHistory();
  }

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
    await _saveHistory();

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
      await _saveHistory();
    }
  }

  /// Regenerate the last assistant response by identifying the last user query,
  /// clearing it and any subsequent assistant response, and submitting it again.
  Future<void> regenerate() async {
    if (state.isGenerating) return;

    final messages = List<ChatMessage>.from(state.messages);
    if (messages.isEmpty) return;

    int lastUserIndex = -1;
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].role == 'user') {
        lastUserIndex = i;
        break;
      }
    }

    if (lastUserIndex == -1) return;

    final lastUserMsgText = messages[lastUserIndex].content;

    // Remove last user message and everything after it
    final newHistory = messages.sublist(0, lastUserIndex);
    emit(state.copyWith(messages: newHistory));
    await _saveHistory();

    // Re-run send with that message
    await send(lastUserMsgText);
  }

  // NOTE: deliberately no model unload in close() — the model belongs to the
  // voice screen's lifecycle. Closing the chat must not free RAM the voice
  // assistant is still using.
}
