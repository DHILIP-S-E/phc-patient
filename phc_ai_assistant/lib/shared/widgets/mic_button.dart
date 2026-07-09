// ============================================================
// PHC AI Assistant - Animated Microphone Button
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phc_ai_assistant/shared/theme/app_colors.dart';

class MicButton extends StatefulWidget {
  final bool isListening;
  final bool isDisabled;
  final VoidCallback onTap;
  final double size;
  final bool showCheckmark;

  const MicButton({
    super.key,
    required this.isListening,
    required this.onTap,
    this.isDisabled = false,
    this.size = 80,
    this.showCheckmark = false,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MicButton old) {
    super.didUpdateWidget(old);
    if (widget.isListening && !old.isListening) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening && old.isListening) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isDisabled) return;
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isListening
        ? AppColors.micActive
        : widget.isDisabled
            ? AppColors.textDisabled
            : AppColors.primary;

    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing outer ring (only when listening)
          if (widget.isListening)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.micActive.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          // Second pulse ring
          if (widget.isListening)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: (_pulseAnimation.value - 0.15).clamp(1.0, 1.3),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.micActive.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
          // Main button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.isListening ? widget.size * 0.88 : widget.size * 0.78,
            height: widget.isListening ? widget.size * 0.88 : widget.size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.5),
                  blurRadius: widget.isListening ? 24 : 12,
                  spreadRadius: widget.isListening ? 4 : 0,
                ),
              ],
            ),
            child: Icon(
              // ✓ while listening: tap to finish speaking and send. (mic to start)
              widget.isListening
                  ? (widget.showCheckmark ? Icons.check_rounded : Icons.mic_rounded)
                  : Icons.mic_rounded,
              color: Colors.white,
              size: widget.size * 0.42,
            ),
          ),
        ],
      ),
    );
  }
}
