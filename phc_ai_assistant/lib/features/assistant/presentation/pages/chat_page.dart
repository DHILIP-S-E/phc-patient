// ============================================================
// PHC AI Assistant - Text Chat Page
// A SEPARATE, text-only chat. Uses its own ChatCubit (independent conversation
// from the voice assistant) and streams the reply word-by-word. No voice here.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/chat_cubit.dart';

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
                          return _ChatBubble(
                            text: m.content,
                            isUser: m.role == 'user',
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
  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: isUser ? null : Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.textPrimary,
            height: 1.4,
          ),
        ),
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
