// ============================================================
// PHC AI Assistant - Text Chat Page
// A SEPARATE, text-only chat. Uses its own ChatCubit (independent conversation
// from the voice assistant) and streams the reply word-by-word. No voice here.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phc_ai_assistant/shared/theme/app_colors.dart';
import 'package:phc_ai_assistant/features/chat/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final cubit = context.read<ChatCubit>();
    if (cubit.state.isGenerating) return; // already busy
    cubit.send(text);
    _controller.clear();
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  void _stop() => context.read<ChatCubit>().cancel();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Chat with Aarogya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Clear',
            onPressed: () => context.read<ChatCubit>().clear(),
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          _scrollToBottom();
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ));
          }
        },
        builder: (context, state) {
          final msgs = state.messages;
          final busy = state.isGenerating;
          // Show "Thinking…" only until the first token streams in; after that
          // the growing assistant bubble is shown instead.
          final waitingFirstToken =
              busy && (msgs.isEmpty || msgs.last.role == 'user');
          return Column(
            children: [
              Expanded(
                child: (msgs.isEmpty && !busy)
                    ? Center(
                        child: Text(
                          'Type your health question below',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: msgs.length + (waitingFirstToken ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (waitingFirstToken && i == msgs.length) {
                            return const _ThinkingBubble();
                          }
                          final m = msgs[i];
                          final isLastAssistant = m.role == 'assistant' &&
                              i == msgs.lastIndexWhere((msg) => msg.role == 'assistant');
                          return _ChatBubble(
                            text: m.content,
                            isUser: m.role == 'user',
                            isLastAssistant: isLastAssistant,
                            isGenerating: busy,
                            onCopy: () {
                              Clipboard.setData(ClipboardData(text: m.content));
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                  content: Text('Response copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ));
                            },
                            onRegenerate: () {
                              context.read<ChatCubit>().regenerate();
                            },
                          );
                        },
                      ),
              ),
              _InputBar(
                  controller: _controller,
                  busy: busy,
                  onSend: _send,
                  onStop: _stop),
            ],
          );
        },
      ),
    );
  }
}

// ── One chat bubble ───────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isLastAssistant;
  final bool isGenerating;
  final VoidCallback? onCopy;
  final VoidCallback? onRegenerate;

  const _ChatBubble({
    required this.text,
    required this.isUser,
    this.isLastAssistant = false,
    this.isGenerating = false,
    this.onCopy,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : AppColors.glassWhite,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isUser ? null : Border.all(color: AppColors.glassBorder),
            ),
            child: isUser
                ? Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 15,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarkdownBody(
                        data: text,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(
                            color: AppColors.textPrimary,
                            height: 1.4,
                            fontSize: 15,
                          ),
                          code: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13.5,
                            color: AppColors.accentLight,
                            backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
                          ),
                          codeblockPadding: const EdgeInsets.all(12),
                          codeblockDecoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.5)),
                          ),
                          h1: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          h2: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          h3: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          listBullet: const TextStyle(color: AppColors.primaryLight, fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            color: AppColors.textSecondary,
                            tooltip: 'Copy response',
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                            onPressed: onCopy,
                          ),
                          if (isLastAssistant) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.autorenew_rounded, size: 16),
                              color: isGenerating ? AppColors.textDisabled : AppColors.textSecondary,
                              tooltip: 'Regenerate response',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              onPressed: isGenerating ? null : onRegenerate,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Animated "thinking" bubble with elapsed seconds ───────
class _ThinkingBubble extends StatefulWidget {
  const _ThinkingBubble();
  @override
  State<_ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<_ThinkingBubble> {
  int _seconds = 0;
  late final Stream<int> _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(seconds: 1), (i) => i + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            StreamBuilder<int>(
              stream: _ticker,
              builder: (context, snap) {
                _seconds = snap.data ?? _seconds;
                return Text(
                  'Thinking…  ${_seconds}s',
                  style: TextStyle(color: AppColors.textTertiary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom input bar ──────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSend;
  final VoidCallback onStop;
  const _InputBar(
      {required this.controller,
      required this.busy,
      required this.onSend,
      required this.onStop});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText:
                      busy ? 'Waiting for reply…' : 'Type your health question…',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.glassWhite,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              // While generating, this becomes a Stop button so the user can
              // interrupt the reply instead of waiting for it to finish.
              onTap: busy ? onStop : onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: busy ? AppColors.error : AppColors.primary,
                ),
                child: Icon(
                  busy ? Icons.stop_rounded : Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
