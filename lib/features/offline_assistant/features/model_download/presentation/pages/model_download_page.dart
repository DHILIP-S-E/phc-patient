// ============================================================
// PHC AI Assistant - Model Download Page
// Beautiful full-screen download UI with animations
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/model_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_formatter.dart';
import '../bloc/model_download_bloc.dart';
import '../bloc/model_download_event.dart';
import '../bloc/model_download_state.dart';

class ModelDownloadPage extends StatefulWidget {
  /// Called once the model is downloaded/verified and the user taps "Start
  /// Assistant" — lets the host screen swap in the assistant UI instead of
  /// navigating to a named route the host app doesn't register.
  final VoidCallback? onReady;

  const ModelDownloadPage({super.key, this.onReady});

  @override
  State<ModelDownloadPage> createState() => _ModelDownloadPageState();
}

class _ModelDownloadPageState extends State<ModelDownloadPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Trigger model check
    context.read<ModelDownloadBloc>().add(const CheckModelEvent());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<ModelDownloadBloc, ModelDownloadState>(
            builder: (context, state) {
              return _buildContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ModelDownloadState state) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 48),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildModelArtwork(state),
                const SizedBox(height: 40),
                _buildModelCard(state),
                const SizedBox(height: 28),
                _buildProgressSection(state),
                const Spacer(),
                _buildActionButtons(context, state),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // PHC Logo badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PHC AI Assistant',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'AI Model\nSetup',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Download Gemma 3 1B — your offline\nhealthcare AI companion',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildModelArtwork(ModelDownloadState state) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Rotating orbit ring
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, child) => Transform.rotate(
              angle: _rotateController.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(200, 200),
                painter: _OrbitPainter(progress: state.progress?.progress ?? 0),
              ),
            ),
          ),
          // Center brain/AI icon
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface,
                  AppColors.surfaceVariant,
                ],
              ),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.5,
              ),
              boxShadow: AppColors.avatarShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getPhaseIcon(state.phase),
                  size: 52,
                  color: _getPhaseColor(state.phase),
                ),
                const SizedBox(height: 4),
                Text(
                  _getPhaseLabel(state.phase, state),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelCard(ModelDownloadState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.memory_rounded, 'Model', ModelConstants.modelName),
          const Divider(height: 16, color: AppColors.glassWhite),
          _buildInfoRow(Icons.tag_rounded, 'Version', ModelConstants.modelVersion),
          const Divider(height: 16, color: AppColors.glassWhite),
          _buildInfoRow(
            Icons.storage_rounded,
            'Size',
            SizeFormatter.format(ModelConstants.modelSizeBytes),
          ),
          const Divider(height: 16, color: AppColors.glassWhite),
          _buildInfoRow(Icons.wifi_off_rounded, 'Mode', 'Fully Offline'),
          const Divider(height: 16, color: AppColors.glassWhite),
          _buildInfoRow(Icons.language_rounded, 'Languages', '12 Indian Languages'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryLight),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(ModelDownloadState state) {
    if (state.phase == DownloadPhase.initial ||
        state.phase == DownloadPhase.checking ||
        state.phase == DownloadPhase.notDownloaded) {
      return const SizedBox.shrink();
    }

    if (state.phase == DownloadPhase.ready) {
      return _buildReadyBadge();
    }

    if (state.phase == DownloadPhase.error) {
      return _buildErrorCard(state.errorMessage ?? 'An error occurred');
    }

    final progress = state.progress;

    if (state.phase == DownloadPhase.verifying) {
      return _buildVerifyingSection(state.verificationProgress);
    }

    if (progress == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: progress.progress,
            minHeight: 10,
            backgroundColor: AppColors.downloadTrack,
            valueColor: AlwaysStoppedAnimation<Color>(
              state.isPaused ? AppColors.warning : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStat(
              '${(progress.progress * 100).toStringAsFixed(1)}%',
              'Complete',
            ),
            _buildStat(
              SizeFormatter.formatSpeed(progress.speedBytesPerSecond),
              'Speed',
            ),
            _buildStat(
              SizeFormatter.format(progress.remainingBytes),
              'Remaining',
            ),
            _buildStat(
              SizeFormatter.formatEta(progress.etaSeconds),
              'ETA',
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Downloaded / Total
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${SizeFormatter.format(progress.downloadedBytes)} / ${SizeFormatter.format(progress.totalBytes)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ),
        if (state.isPaused) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
            ),
            child: Text(
              '⏸ Download Paused',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.warning,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    );
  }

  Widget _buildVerifyingSection(double progress) {
    return Column(
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _rotateController,
              builder: (context, child) => Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: const Icon(Icons.verified_rounded,
                    color: AppColors.secondary, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Verifying integrity…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.downloadTrack,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildReadyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 24),
          const SizedBox(width: 12),
          Text(
            'AI Model Ready — Fully Offline',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.errorLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ModelDownloadState state) {
    switch (state.phase) {
      case DownloadPhase.ready:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: widget.onReady,
            icon: const Icon(Icons.mic_rounded),
            label: const Text('Start Assistant'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );

      case DownloadPhase.notDownloaded:
      case DownloadPhase.initial:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                context.read<ModelDownloadBloc>().add(const StartDownloadEvent()),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download AI Model'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );

      case DownloadPhase.downloading:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.read<ModelDownloadBloc>().add(const PauseDownloadEvent()),
                icon: const Icon(Icons.pause_rounded),
                label: const Text('Pause'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () =>
                  context.read<ModelDownloadBloc>().add(const CancelDownloadEvent()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.close_rounded),
            ),
          ],
        );

      case DownloadPhase.paused:
        return Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () =>
                    context.read<ModelDownloadBloc>().add(const ResumeDownloadEvent()),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Resume'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () =>
                  context.read<ModelDownloadBloc>().add(const CancelDownloadEvent()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.close_rounded),
            ),
          ],
        );

      case DownloadPhase.verifying:
      case DownloadPhase.checking:
        return const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );

      case DownloadPhase.error:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                context.read<ModelDownloadBloc>().add(const RetryDownloadEvent()),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry Download'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
    }
  }

  IconData _getPhaseIcon(DownloadPhase phase) {
    switch (phase) {
      case DownloadPhase.ready:
        return Icons.psychology_rounded;
      case DownloadPhase.downloading:
        return Icons.download_rounded;
      case DownloadPhase.paused:
        return Icons.pause_rounded;
      case DownloadPhase.verifying:
        return Icons.verified_rounded;
      case DownloadPhase.error:
        return Icons.error_outline_rounded;
      default:
        return Icons.smart_toy_rounded;
    }
  }

  Color _getPhaseColor(DownloadPhase phase) {
    switch (phase) {
      case DownloadPhase.ready:
        return AppColors.success;
      case DownloadPhase.error:
        return AppColors.error;
      case DownloadPhase.verifying:
        return AppColors.secondary;
      default:
        return AppColors.primaryLight;
    }
  }

  String _getPhaseLabel(DownloadPhase phase, ModelDownloadState state) {
    switch (phase) {
      case DownloadPhase.ready:
        return 'READY';
      case DownloadPhase.downloading:
        return '${((state.progress?.progress ?? 0) * 100).toStringAsFixed(0)}%';
      case DownloadPhase.paused:
        return 'PAUSED';
      case DownloadPhase.verifying:
        return 'VERIFYING';
      case DownloadPhase.error:
        return 'ERROR';
      default:
        return 'AI MODEL';
    }
  }
}

// ── Orbit Ring Painter ────────────────────────────────────
class _OrbitPainter extends CustomPainter {
  final double progress;

  _OrbitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Track ring
    final trackPaint = Paint()
      ..color = AppColors.glassWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = AppColors.primaryGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Dots on the ring
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final dotPaint = Paint()
        ..color = i / 8 < progress
            ? AppColors.primary
            : AppColors.glassWhite.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}
