// ============================================================
// PHC AI Assistant - Waveform Widget
// Real-time audio visualization using audio_waveforms package
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phc_ai_assistant/shared/theme/app_colors.dart';

/// A reactive waveform bar visualizer.
/// When [isActive] is true, bars animate with random heights.
/// When false, bars display a flat baseline.
class WaveformWidget extends StatefulWidget {
  final bool isActive;
  final Color color;
  final int barCount;
  final double height;

  const WaveformWidget({
    super.key,
    this.isActive = false,
    this.color = AppColors.waveformActive,
    this.barCount = 30,
    this.height = 48,
  });

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _rng = math.Random();
  List<double> _heights = [];

  @override
  void initState() {
    super.initState();
    _heights = List.generate(widget.barCount, (_) => 0.1);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(_updateHeights)..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.isActive) {
          _controller.forward(from: 0);
        }
      });

    if (widget.isActive) _controller.forward();
  }

  @override
  void didUpdateWidget(WaveformWidget old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _controller.forward(from: 0);
    } else if (!widget.isActive && old.isActive) {
      _controller.stop();
      setState(() {
        _heights = List.generate(widget.barCount, (_) => 0.1);
      });
    }
  }

  void _updateHeights() {
    if (!widget.isActive) return;
    setState(() {
      _heights = List.generate(widget.barCount, (i) {
        // Natural waveform: higher in middle, lower at edges
        final center = widget.barCount / 2;
        final dist = (i - center).abs() / center;
        final maxH = 1.0 - dist * 0.5;
        return (_rng.nextDouble() * maxH).clamp(0.05, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (i) {
          final h = _heights[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            width: 3,
            height: widget.height * h,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.4 + h * 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
