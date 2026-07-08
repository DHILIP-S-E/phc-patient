import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/live_assistant_provider.dart';
import '../../theme/app_theme.dart';

/// Full-duplex Gemini Live citizen assistant tab. One button starts/stops
/// continuous listening (not push-to-talk — the mic stays open the whole
/// time, matching phc_api/services/patient/live_assistant_service.py's
/// full-duplex relay), a status pill reflects [LiveAssistantState], and a
/// running transcript is fed by the server's JSON transcript frames.
class LiveAssistantScreen extends ConsumerStatefulWidget {
  const LiveAssistantScreen({super.key});

  @override
  ConsumerState<LiveAssistantScreen> createState() => _LiveAssistantScreenState();
}

class _LiveAssistantScreenState extends ConsumerState<LiveAssistantScreen> {
  final List<String> _transcriptLog = [];
  String? _lastLogged;

  @override
  Widget build(BuildContext context) {
    final assistantState = ref.watch(liveAssistantProvider);
    final transcript = switch (assistantState) {
      AssistantListening(:final transcript) => transcript,
      AssistantSpeaking(:final transcript) => transcript,
      _ => null,
    };
    if (transcript != null && transcript != _lastLogged) {
      _lastLogged = transcript;
      _transcriptLog.add(transcript);
    }

    final isActive = assistantState is AssistantListening || assistantState is AssistantSpeaking;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('GramCare Assistant', style: AppText.display(size: 22)),
              const SizedBox(height: 4),
              const Text(
                'Speak in your own language — ask about your appointments, '
                'vaccinations, screenings, or queue status.',
                textAlign: TextAlign.center,
                style: AppText.body,
              ),
              const SizedBox(height: 20),
              _StatusPill(state: assistantState),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _transcriptLog.isEmpty
                      ? const Center(
                          child: Text('Your conversation will appear here.', style: AppText.label),
                        )
                      : ListView.separated(
                          reverse: true,
                          itemCount: _transcriptLog.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final entry = _transcriptLog[_transcriptLog.length - 1 - index];
                            return Text(entry, style: const TextStyle(fontSize: 14, color: AppColors.ink));
                          },
                        ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  final notifier = ref.read(liveAssistantProvider.notifier);
                  if (isActive) {
                    await notifier.stop();
                  } else {
                    setState(() {
                      _transcriptLog.clear();
                      _lastLogged = null;
                    });
                    await notifier.start();
                  }
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.redAccent : AppColors.cta,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.stop_rounded : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isActive ? 'Tap to stop' : 'Tap to talk',
                style: AppText.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final LiveAssistantState state;

  const _StatusPill({required this.state});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      AssistantIdle() => ('Ready', AppColors.muted),
      AssistantListening() => ('Listening…', AppColors.primary),
      AssistantSpeaking() => ('Speaking…', AppColors.teal),
      AssistantError(:final message) => (message, Colors.redAccent),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
