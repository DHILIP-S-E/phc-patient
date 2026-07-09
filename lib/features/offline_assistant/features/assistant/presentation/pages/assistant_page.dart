// ============================================================
// PHC AI Assistant - Main Assistant Page
// Full-screen voice AI interface with 3D avatar
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/avatar/controllers/avatar_controller.dart';
import '../../../../features/avatar/widgets/avatar_widget.dart';
import '../../../voice_loop/voice_loop_manager.dart';
import '../../../voice_loop/voice_loop_state.dart';
import '../bloc/chat_cubit.dart';
import 'chat_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../widgets/mic_button.dart';
import '../widgets/waveform_widget.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage>
    with TickerProviderStateMixin {
  late AvatarController _avatarController;
  late AnimationController _subtitleController;
  late Animation<double> _subtitleAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _idleRestartTimer;

  @override
  void initState() {
    super.initState();
    // Use the SAME AvatarController the AssistantBloc drives (registered as a
    // singleton in DI). Previously the page created its own throwaway controller,
    // so the bloc's greeting nod and TTS-driven lip-sync animated an off-screen
    // instance while the visible avatar never reacted to speech.
    _avatarController = sl<AvatarController>();

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _subtitleAnimation = CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOut,
    );

    // Pulsing dot animation for live transcription indicator.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Initialize assistant
    context.read<AssistantBloc>().add(const InitializeAssistantEvent());
  }

  @override
  void dispose() {
    _idleRestartTimer?.cancel();
    _subtitleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AssistantBloc, AssistantState>(
        listener: _onStateChange,
        builder: (context, state) {
          return Stack(
            children: [
              // Gradient background
              _buildBackground(),
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(context, state),
                    _buildSttDownloadBanner(state),
                    _buildAvatarSection(size, state),
                    _buildSubtitleSection(state),
                    _buildWaveformSection(state),
                    _buildControlSection(context, state),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Loading overlay
              if (state.phase == AssistantPhase.initializing)
                _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  void _onStateChange(BuildContext context, AssistantState state) {
    // Missing voice/speech pack → banner with an "Install" button (no more
    // surprise redirect to system settings on language change).
    if (state.voicePackPrompt != null && state.voicePackPrompt!.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.voicePackPrompt!),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Install',
            onPressed: () => context
                .read<AssistantBloc>()
                .add(const InstallVoicePacksEvent()),
          ),
        ));
    }

    // Surface errors / "didn't catch that" feedback. Shown for any phase so a
    // no-match while listening isn't silent.
    if (state.errorMessage?.isNotEmpty ?? false) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ));
    }

    // Auto-restart listening when we fall back to idle (keeps the loop alive
    // even if something breaks the normal speaking→listening transition).
    if (state.phase == AssistantPhase.idle && state.isModelLoaded) {
      _idleRestartTimer?.cancel();
      _idleRestartTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted && context.read<AssistantBloc>().state.phase == AssistantPhase.idle) {
          context.read<AssistantBloc>().add(const StartListeningEvent());
        }
      });
    } else {
      _idleRestartTimer?.cancel();
    }

    // Show the subtitle box whenever there is EITHER the assistant's text OR the
    // user's live speech transcript. Previously it keyed only on currentSubtitle,
    // so while the user was speaking (only partialSpeechText set) the box stayed
    // faded out — you couldn't see what you were saying. forward() (not from:0)
    // avoids re-animating on every streamed word.
    final hasSubtitle = state.currentSubtitle.isNotEmpty ||
        state.partialSpeechText.isNotEmpty;
    if (hasSubtitle) {
      _subtitleController.forward();
    } else {
      _subtitleController.reverse();
    }

    // Update avatar based on phase
    switch (state.phase) {
      case AssistantPhase.listening:
        _avatarController.setListening();
        break;
      case AssistantPhase.processing:
        _avatarController.setThinking();
        break;
      case AssistantPhase.speaking:
        _avatarController.setSpeaking();
        break;
      case AssistantPhase.idle:
        _avatarController.setIdle();
        break;
      default:
        break;
    }
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: CustomPaint(
        painter: _BackgroundParticlePainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AssistantState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // App branding. Wrapped in Flexible + ellipsis so a narrow screen (the
          // 36px RenderFlex overflow) shrinks the text instead of overflowing.
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primaryLight,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aarogya',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Text(
                        'PHC AI Assistant',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Language selector
          _buildLanguageChip(context, state),
          const SizedBox(width: 4),
          // Chat view (text chat — type and read replies as bubbles)
          IconButton(
            icon: const Icon(Icons.forum_rounded,
                color: AppColors.textSecondary, size: 22),
            tooltip: 'Chat',
            onPressed: () {
              // Open the SEPARATE text-only chat with its OWN ChatCubit (its own
              // conversation). We hand it the currently-selected language once so
              // replies match, but the two conversations never mix.
              final lang = context.read<AssistantBloc>().state.languageCode;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider<ChatCubit>(
                  create: (_) => sl<ChatCubit>(param1: lang),
                  child: const ChatPage(),
                ),
              ));
            },
          ),
          // Settings
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 22),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
    );
  }

  // Shows offline speech-model download status so the user knows what's happening
  // during first-run setup (and when it's done). Hidden once ready.
  Widget _buildSttDownloadBanner(AssistantState state) {
    final p = state.sttDownloadProgress;
    if (p >= 1.0) return const SizedBox.shrink();
    final isError = p < 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isError ? AppColors.error : AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.download_rounded,
                  size: 16,
                  color: isError ? AppColors.error : AppColors.primaryLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isError
                      ? 'Speech model download failed — check your connection.'
                      : 'Downloading offline speech model… ${(p * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
          if (!isError) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: p == 0 ? null : p,
                minHeight: 5,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageChip(BuildContext context, AssistantState state) {
    final lang = LanguageConstants.getLanguage(state.languageCode);
    return GestureDetector(
      onTap: () => _showLanguageSheet(context, state),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              lang.name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded,
                size: 14, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(Size size, AssistantState state) {
    final avatarSize = size.width * 0.72;
    return Expanded(
      flex: 6,
      child: Center(
        // FittedBox scales the avatar+text down when the keyboard shrinks the
        // area, instead of overflowing (the 117px yellow/black overflow bar).
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarWidget(
              controller: _avatarController,
              size: avatarSize,
            ),
            const SizedBox(height: 12),
            // Status text under avatar
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _getStatusText(state.phase),
                key: ValueKey(state.phase),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.5,
                    ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildSubtitleSection(AssistantState state) {
    final isListening = state.phase == AssistantPhase.listening;
    final isProcessing = state.phase == AssistantPhase.processing;

    // LIVE LISTENING: show real-time partial transcript word-by-word.
    if (isListening) {
      final spoken = state.partialSpeechText;
      final showPlaceholder = spoken.isEmpty;
      return _transcriptBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pulsing live dot
            Padding(
              padding: const EdgeInsets.only(top: 3, right: 8),
              child: FadeTransition(
                opacity: _pulseAnimation,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.micActive,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                showPlaceholder ? 'Listening…' : spoken,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: showPlaceholder
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                      height: 1.4,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        highlight: true,
      );
    }

    // PROCESSING: show streaming AI tokens as they arrive.
    if (isProcessing) {
      final streamed = state.currentSubtitle;
      return FadeTransition(
        opacity: _subtitleAnimation,
        child: _transcriptBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2, right: 8),
                child: Icon(Icons.smart_toy_rounded,
                    size: 14, color: AppColors.accent),
              ),
              Expanded(
                child: Text(
                  streamed.isEmpty ? '…' : streamed,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: streamed.isEmpty
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        height: 1.4,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Otherwise show the assistant subtitle (or the just-finished user text)
    // with a gentle fade.
    final displayText = state.currentSubtitle.isNotEmpty
        ? state.currentSubtitle
        : state.partialSpeechText;
    if (displayText.isEmpty) return const SizedBox(height: 60);

    return FadeTransition(
      opacity: _subtitleAnimation,
      child: _transcriptBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              state.isSpeaking ? Icons.volume_up_rounded : Icons.person_rounded,
              size: 16,
              color: state.isSpeaking ? AppColors.accent : AppColors.primaryLight,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transcriptBox({
    required Widget child,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? AppColors.micActive : AppColors.glassBorder,
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildWaveformSection(AssistantState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: WaveformWidget(
        isActive: state.isListening || state.isSpeaking,
        color: state.isListening
            ? AppColors.micActive
            : state.isSpeaking
                ? AppColors.accent
                : AppColors.waveformActive,
        barCount: 28,
        height: 44,
      ),
    );
  }

  Widget _buildControlSection(BuildContext context, AssistantState state) {
    // Mic stays enabled during processing so the user can barge in (tap to stop
    // the reply and start talking). Only disabled while first initializing.
    final isDisabled = state.phase == AssistantPhase.initializing;

    return Column(
      children: [
        // Helper text — during processing show a live elapsed-seconds counter so
        // the user can see it's working (on-device generation takes ~20-40s).
        state.phase == AssistantPhase.processing
            ? const _ThinkingTimer()
            : Text(
                _getHintText(state.phase),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
              ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Clear conversation
            _buildCircleAction(
              icon: Icons.refresh_rounded,
              tooltip: 'Clear',
              onTap: () =>
                  context.read<AssistantBloc>().add(const ClearConversationEvent()),
              size: 44,
            ),
            const SizedBox(width: 28),
            // Main mic button
            MicButton(
              isListening: state.isListening,
              showCheckmark: state.showCheckmark,
              isDisabled: isDisabled,
              size: 88,
              onTap: () {
                if (state.isListening) {
                  context.read<AssistantBloc>().add(const StopListeningEvent());
                } else if (state.isSpeaking) {
                  context.read<AssistantBloc>().add(const StopSpeakingEvent());
                } else {
                  context.read<AssistantBloc>().add(const StartListeningEvent());
                }
              },
            ),
            const SizedBox(width: 28),
            // Stop (during reply) / history. Lets the user cancel a running
            // generation or ongoing speech.
            _buildCircleAction(
              icon: (state.isSpeaking || state.isProcessing)
                  ? Icons.stop_circle_rounded
                  : Icons.history_rounded,
              tooltip: (state.isSpeaking || state.isProcessing)
                  ? 'Stop'
                  : 'History',
              color: (state.isSpeaking || state.isProcessing)
                  ? AppColors.error
                  : null,
              onTap: () {
                if (state.isProcessing) {
                  context.read<AssistantBloc>().add(const CancelGenerationEvent());
                } else if (state.isSpeaking) {
                  context.read<AssistantBloc>().add(const StopSpeakingEvent());
                } else {
                  _showHistorySheet(context, state);
                }
              },
              size: 44,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required double size,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glassWhite,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, size: size * 0.45, color: color ?? AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.background.withValues(alpha: 0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Loading AI Model…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheets ─────────────────────────────────────────

  void _showLanguageSheet(BuildContext context, AssistantState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => _LanguageSheet(
          currentCode: state.languageCode,
          onSelect: (code) {
            context.read<AssistantBloc>().add(ChangeLanguageEvent(code));
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _showHistorySheet(BuildContext context, AssistantState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => _ConversationHistorySheet(
          conversation: state.conversation,
          scrollController: scrollController,
        ),
      ),
    );
  }

  String _getStatusText(AssistantPhase phase) {
    switch (phase) {
      case AssistantPhase.initializing:
        return 'INITIALIZING…';
      case AssistantPhase.idle:
        return 'TAP MIC TO SPEAK';
      case AssistantPhase.listening:
        return '🎤 LISTENING…';
      case AssistantPhase.processing:
        return '🧠 THINKING…';
      case AssistantPhase.speaking:
        return '🔊 AI SPEAKING…';
      case AssistantPhase.error:
        return 'ERROR';
    }
  }

  String _getHintText(AssistantPhase phase) {
    switch (phase) {
      case AssistantPhase.idle:
        return 'Ask me about your health symptoms';
      case AssistantPhase.listening:
        return 'Listening… speak to talk';
      case AssistantPhase.processing:
        return 'Processing your message…';
      case AssistantPhase.speaking:
        return 'Tap mic to interrupt';
      default:
        return '';
    }
  }
}

// ── Live "thinking" timer ─────────────────────────────────
// Shows an elapsed-seconds counter while the model generates, so the wait feels
// alive (on-device 1B inference is ~20-40s). Auto-starts/stops because it is only
// mounted while phase == processing.
class _ThinkingTimer extends StatefulWidget {
  const _ThinkingTimer();

  @override
  State<_ThinkingTimer> createState() => _ThinkingTimerState();
}

class _ThinkingTimerState extends State<_ThinkingTimer> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Thinking…  ${_seconds}s   (offline AI runs on your phone — please wait)',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
    );
  }
}

// ── Language Selection Sheet ──────────────────────────────
class _LanguageSheet extends StatelessWidget {
  final String currentCode;
  final void Function(String code) onSelect;

  const _LanguageSheet({
    required this.currentCode,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Language',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Assistant will respond in the selected language',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: LanguageConstants.supportedLanguages.length,
              itemBuilder: (context, i) {
                final lang = LanguageConstants.supportedLanguages[i];
                final isSelected = lang.code == currentCode;
                return GestureDetector(
                  onTap: () => onSelect(lang.code),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                              ),
                              Text(
                                lang.nativeName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Conversation History Sheet ────────────────────────────
class _ConversationHistorySheet extends StatelessWidget {
  final List<ConversationMessage> conversation;
  final ScrollController scrollController;

  const _ConversationHistorySheet({
    required this.conversation,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversation',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: conversation.isEmpty
                ? Center(
                    child: Text(
                      'No conversation yet.\nStart speaking to begin.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: conversation.length,
                    itemBuilder: (context, i) {
                      final msg = conversation[i];
                      final isUser = msg.role == 'user';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary,
                                child: const Icon(Icons.smart_toy_rounded,
                                    size: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? AppColors.glassWhite
                                      : AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUser
                                        ? AppColors.glassBorder
                                        : AppColors.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  msg.content,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.surfaceVariant,
                                child: const Icon(Icons.person_rounded,
                                    size: 16, color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Background Particle Painter ───────────────────────────
class _BackgroundParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    // Subtle blobs in corners
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.1), 120, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 80, paint);
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.85), 100, paint);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.75), 140, paint);
  }

  @override
  bool shouldRepaint(_BackgroundParticlePainter _) => false;
}
