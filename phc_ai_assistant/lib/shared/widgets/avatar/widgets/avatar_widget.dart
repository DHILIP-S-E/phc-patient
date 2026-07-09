// ============================================================
// PHC AI Assistant - Avatar Widget
// Procedural 3D-style healthcare avatar using Flutter Canvas
// Real-time animated: blinking, lip sync, head movement, expressions
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phc_ai_assistant/shared/theme/app_colors.dart';
import '../controllers/avatar_controller.dart';
import '../models/avatar_state.dart' as state_model;

class AvatarWidget extends StatelessWidget {
  final AvatarController controller;
  final double size;

  const AvatarWidget({
    super.key,
    required this.controller,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return _buildAvatarWithEffects(context);
      },
    );
  }

  Widget _buildAvatarWithEffects(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient glow based on state
          _buildStateGlow(),
          // Outer decorative ring
          _buildRing(),
          // Main avatar
          _buildAvatar(),
          // State indicator badge
          _buildStateBadge(),
        ],
      ),
    );
  }

  Widget _buildStateGlow() {
    final color = _getStateGlowColor();
    final radius = _getGlowRadius();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: size * 0.95,
      height: size * 0.95,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: radius,
            spreadRadius: radius * 0.3,
          ),
        ],
      ),
    );
  }

  Widget _buildRing() {
    return SizedBox(
      width: size * 0.92,
      height: size * 0.92,
      child: CustomPaint(
        painter: _RingPainter(
          state: controller.avatarState,
          breathPhase: controller.breathPhase,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(controller.headTilt * 0.2)
        ..translateByDouble(
          0.0,
          // Breathing bob
          -math.sin(controller.breathPhase) * 3,
          0.0,
          0.0,
        ),
      child: Container(
        width: size * 0.82,
        height: size * 0.82,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.4),
            colors: [
              const Color(0xFF2A3F6F),
              AppColors.surface,
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(
            color: _getStateGlowColor().withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: CustomPaint(
            size: Size(size * 0.82, size * 0.82),
            painter: _AvatarFacePainter(
              gender: controller.config.gender,
              state: controller.avatarState,
              emotion: controller.emotion,
              mouthOpenness: controller.mouthOpenness,
              isBlinking: controller.isBlinking,
              headTilt: controller.headTilt,
              breathPhase: controller.breathPhase,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateBadge() {
    return Positioned(
      bottom: size * 0.03,
      right: size * 0.08,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _getStateGlowColor().withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: _getStateGlowColor().withValues(alpha: 0.5),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStateIcon(),
            const SizedBox(width: 4),
            Text(
              _getStateLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIcon() {
    switch (controller.avatarState) {
      case state_model.AvatarState.listening:
        return const _PulsingDot(color: AppColors.micActive);
      case state_model.AvatarState.thinking:
        return const SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.white,
          ),
        );
      case state_model.AvatarState.speaking:
        return const Icon(Icons.volume_up_rounded, size: 10, color: Colors.white);
      default:
        return const SizedBox(width: 8, height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        );
    }
  }

  Color _getStateGlowColor() {
    switch (controller.avatarState) {
      case state_model.AvatarState.listening:
        return AppColors.micActive;
      case state_model.AvatarState.thinking:
        return AppColors.secondary;
      case state_model.AvatarState.speaking:
        return AppColors.accent;
      case state_model.AvatarState.greeting:
        return AppColors.primaryLight;
      default:
        return AppColors.primary;
    }
  }

  double _getGlowRadius() {
    switch (controller.avatarState) {
      case state_model.AvatarState.listening:
        return 40;
      case state_model.AvatarState.speaking:
        return 50;
      case state_model.AvatarState.thinking:
        return 30;
      default:
        return 20;
    }
  }

  String _getStateLabel() {
    switch (controller.avatarState) {
      case state_model.AvatarState.idle:
        return 'READY';
      case state_model.AvatarState.listening:
        return 'LISTENING';
      case state_model.AvatarState.thinking:
        return 'THINKING';
      case state_model.AvatarState.speaking:
        return 'SPEAKING';
      case state_model.AvatarState.greeting:
        return 'HELLO';
      default:
        return 'READY';
    }
  }
}

// ── Face Painter ──────────────────────────────────────────
class _AvatarFacePainter extends CustomPainter {
  final String gender;
  final state_model.AvatarState state;
  final state_model.AvatarEmotion emotion;
  final double mouthOpenness;
  final bool isBlinking;
  final double headTilt;
  final double breathPhase;

  _AvatarFacePainter({
    required this.gender,
    required this.state,
    required this.emotion,
    required this.mouthOpenness,
    required this.isBlinking,
    required this.headTilt,
    required this.breathPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = size.width * 0.38;

    // Slight breathing scale
    final breathScale = 1.0 + math.sin(breathPhase) * 0.008;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(breathScale);
    canvas.translate(-center.dx, -center.dy);

    // ── Background gradient face ───────────────────────────
    _drawFaceBase(canvas, center, faceRadius, size);

    // ── Neck ──────────────────────────────────────────────
    _drawNeck(canvas, center, size);

    // ── Hair ──────────────────────────────────────────────
    _drawHair(canvas, center, faceRadius, size);

    // ── Clothing (PHC scrubs) ─────────────────────────────
    _drawClothing(canvas, center, size);

    // ── Eyebrows ──────────────────────────────────────────
    _drawEyebrows(canvas, center, size, faceRadius);

    // ── Eyes ──────────────────────────────────────────────
    _drawEyes(canvas, center, size, faceRadius);

    // ── Nose ──────────────────────────────────────────────
    _drawNose(canvas, center, size);

    // ── Mouth ─────────────────────────────────────────────
    _drawMouth(canvas, center, size);

    canvas.restore();
  }

  void _drawFaceBase(Canvas canvas, Offset center, double r, Size size) {
    // Skin gradient
    final skinPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: gender == 'female'
            ? [const Color(0xFFE8C4A0), const Color(0xFFD4956A)]
            : [const Color(0xFFD4956A), const Color(0xFFB87248)],
      ).createShader(Rect.fromCircle(center: center, radius: r));

    canvas.drawCircle(center, r, skinPaint);

    // Face highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - r * 0.15, center.dy - r * 0.25),
        width: r * 0.6,
        height: r * 0.45,
      ),
      highlightPaint,
    );
  }

  void _drawNeck(Canvas canvas, Offset center, Size size) {
    final neckPaint = Paint()
      ..color = gender == 'female'
          ? const Color(0xFFD4956A)
          : const Color(0xFFB87248);
    final neckRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.33),
        width: size.width * 0.16,
        height: size.height * 0.15,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(neckRect, neckPaint);
  }

  void _drawHair(Canvas canvas, Offset center, double r, Size size) {
    final hairPaint = Paint()
      ..color = gender == 'female'
          ? const Color(0xFF1A0A00)
          : const Color(0xFF2D1B00)
      ..style = PaintingStyle.fill;

    if (gender == 'female') {
      // Long hair sides
      final path = Path()
        ..moveTo(center.dx - r * 0.95, center.dy + r * 0.2)
        ..quadraticBezierTo(
          center.dx - r * 1.1, center.dy + r * 0.8,
          center.dx - r * 0.7, center.dy + r * 1.2,
        )
        ..lineTo(center.dx - r * 0.5, center.dy + r * 1.2)
        ..quadraticBezierTo(
          center.dx - r * 0.8, center.dy + r * 0.5,
          center.dx - r * 0.85, center.dy,
        )
        ..close();
      canvas.drawPath(path, hairPaint);

      final pathR = Path()
        ..moveTo(center.dx + r * 0.95, center.dy + r * 0.2)
        ..quadraticBezierTo(
          center.dx + r * 1.1, center.dy + r * 0.8,
          center.dx + r * 0.7, center.dy + r * 1.2,
        )
        ..lineTo(center.dx + r * 0.5, center.dy + r * 1.2)
        ..quadraticBezierTo(
          center.dx + r * 0.8, center.dy + r * 0.5,
          center.dx + r * 0.85, center.dy,
        )
        ..close();
      canvas.drawPath(pathR, hairPaint);

      // Top hair dome
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center.dx, center.dy - r * 0.05), radius: r * 0.98),
        math.pi,
        math.pi,
        false,
        hairPaint,
      );
    } else {
      // Short hair
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center.dx, center.dy - r * 0.02), radius: r * 0.98),
        math.pi * 1.15,
        math.pi * 0.7,
        true,
        hairPaint,
      );
    }
  }

  void _drawClothing(Canvas canvas, Offset center, Size size) {
    // PHC teal scrubs / uniform
    final clothPaint = Paint()
      ..color = const Color(0xFF006D77)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx - size.width * 0.3, center.dy + size.height * 0.42)
      ..lineTo(center.dx - size.width * 0.4, size.height)
      ..lineTo(center.dx + size.width * 0.4, size.height)
      ..lineTo(center.dx + size.width * 0.3, center.dy + size.height * 0.42)
      ..quadraticBezierTo(center.dx, center.dy + size.height * 0.38, 
          center.dx - size.width * 0.3, center.dy + size.height * 0.42)
      ..close();
    canvas.drawPath(path, clothPaint);

    // Collar / white detail
    final collarPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(center.dx - size.width * 0.05, center.dy + size.height * 0.4),
      Offset(center.dx, center.dy + size.height * 0.46),
      collarPaint,
    );
    canvas.drawLine(
      Offset(center.dx + size.width * 0.05, center.dy + size.height * 0.4),
      Offset(center.dx, center.dy + size.height * 0.46),
      collarPaint,
    );

    // Stethoscope hint
    final stethPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.05, center.dy + size.height * 0.47),
        width: size.width * 0.12,
        height: size.height * 0.08,
      ),
      0,
      math.pi,
      false,
      stethPaint,
    );
  }

  void _drawEyebrows(Canvas canvas, Offset center, Size size, double r) {
    final browPaint = Paint()
      ..color = gender == 'female'
          ? const Color(0xFF2D1B00)
          : const Color(0xFF1A0A00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = gender == 'female' ? 2.0 : 3.0
      ..strokeCap = StrokeCap.round;

    final lift = _getBrowLift();

    // Left brow
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - r * 0.35, center.dy - r * 0.28 - lift),
        width: r * 0.45,
        height: r * 0.15,
      ),
      math.pi * 1.2,
      math.pi * 0.6,
      false,
      browPaint,
    );
    // Right brow
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + r * 0.35, center.dy - r * 0.28 - lift),
        width: r * 0.45,
        height: r * 0.15,
      ),
      math.pi * 1.8,
      -math.pi * 0.6,
      false,
      browPaint,
    );
  }

  void _drawEyes(Canvas canvas, Offset center, Size size, double r) {
    final eyeY = center.dy - r * 0.1;
    final leftEyeX = center.dx - r * 0.32;
    final rightEyeX = center.dx + r * 0.32;
    final eyeW = r * 0.22;
    final eyeH = isBlinking ? r * 0.01 : _getEyeOpenness(r);

    // Left eye
    _drawSingleEye(canvas, Offset(leftEyeX, eyeY), eyeW, eyeH, r);
    // Right eye
    _drawSingleEye(canvas, Offset(rightEyeX, eyeY), eyeW, eyeH, r);
  }

  void _drawSingleEye(Canvas canvas, Offset pos, double w, double h, double r) {
    // White sclera
    final scleraPaint = Paint()..color = Colors.white;
    canvas.drawOval(Rect.fromCenter(center: pos, width: w, height: h), scleraPaint);

    if (!isBlinking) {
      // Iris
      final irisPaint = Paint()
        ..color = const Color(0xFF4A3728);
      canvas.drawCircle(pos, h * 0.42, irisPaint);

      // Pupil
      final pupilPaint = Paint()..color = Colors.black;
      canvas.drawCircle(pos, h * 0.22, pupilPaint);

      // Catchlight
      final catchPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
      canvas.drawCircle(
        Offset(pos.dx - h * 0.08, pos.dy - h * 0.1),
        h * 0.09,
        catchPaint,
      );
    }

    // Upper eyelid shadow
    final lidPaint = Paint()
      ..color = const Color(0xFFD4956A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: pos, width: w, height: h),
      math.pi,
      math.pi,
      false,
      lidPaint,
    );
  }

  void _drawNose(Canvas canvas, Offset center, Size size) {
    final nosePaint = Paint()
      ..color = const Color(0xFFC0804A).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final r = size.width * 0.38;
    final noseCenter = Offset(center.dx, center.dy + r * 0.12);

    canvas.drawArc(
      Rect.fromCenter(center: noseCenter, width: r * 0.22, height: r * 0.18),
      0,
      math.pi,
      false,
      nosePaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset center, Size size) {
    final r = size.width * 0.38;
    final mouthCenter = Offset(center.dx, center.dy + r * 0.35);
    final mouthWidth = r * 0.42;

    final smileAmount = _getSmileAmount();
    final openness = mouthOpenness * r * 0.18;

    // Lips
    final lipPaint = Paint()
      ..color = gender == 'female'
          ? const Color(0xFFB5524A)
          : const Color(0xFF8B4A3A)
      ..style = PaintingStyle.fill;

    // Upper lip
    final upperPath = Path()
      ..moveTo(mouthCenter.dx - mouthWidth / 2, mouthCenter.dy)
      ..quadraticBezierTo(
        mouthCenter.dx,
        mouthCenter.dy - smileAmount * 0.6 - 4,
        mouthCenter.dx + mouthWidth / 2,
        mouthCenter.dy,
      );

    if (openness > 2) {
      // Mouth open (speaking)
      upperPath.lineTo(mouthCenter.dx + mouthWidth / 2, mouthCenter.dy + openness);
      upperPath.quadraticBezierTo(
        mouthCenter.dx,
        mouthCenter.dy + smileAmount + openness + 4,
        mouthCenter.dx - mouthWidth / 2,
        mouthCenter.dy + openness,
      );
      upperPath.close();

      // Teeth hint
      final teethPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(mouthCenter.dx, mouthCenter.dy + openness * 0.3),
            width: mouthWidth * 0.65,
            height: openness * 0.5,
          ),
          const Radius.circular(3),
        ),
        teethPaint,
      );
    } else {
      // Mouth closed smile
      upperPath.quadraticBezierTo(
        mouthCenter.dx,
        mouthCenter.dy + smileAmount + 6,
        mouthCenter.dx - mouthWidth / 2,
        mouthCenter.dy,
      );
      upperPath.close();
    }

    canvas.drawPath(upperPath, lipPaint);
  }

  // ── Expression helpers ────────────────────────────────────

  double _getBrowLift() {
    switch (emotion) {
      case state_model.AvatarEmotion.surprised:
        return 8.0;
      case state_model.AvatarEmotion.concerned:
        return -3.0;
      case state_model.AvatarEmotion.thinking:
        return 2.0;
      default:
        return 0.0;
    }
  }

  double _getEyeOpenness(double r) {
    switch (state) {
      case state_model.AvatarState.thinking:
        return r * 0.14; // Slightly squinted
      case state_model.AvatarState.greeting:
        return r * 0.22; // Wide eyes
      default:
        return r * 0.18;
    }
  }

  double _getSmileAmount() {
    switch (emotion) {
      case state_model.AvatarEmotion.happy:
        return 12.0;
      case state_model.AvatarEmotion.neutral:
        return 4.0;
      case state_model.AvatarEmotion.concerned:
        return -2.0;
      default:
        return 6.0;
    }
  }

  @override
  bool shouldRepaint(_AvatarFacePainter old) =>
      old.mouthOpenness != mouthOpenness ||
      old.isBlinking != isBlinking ||
      old.emotion != emotion ||
      old.state != state ||
      old.headTilt != headTilt ||
      old.breathPhase != breathPhase;
}

// ── Ring Painter ──────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final state_model.AvatarState state;
  final double breathPhase;

  _RingPainter({required this.state, required this.breathPhase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 6;

    final alpha = (0.3 + math.sin(breathPhase) * 0.1).clamp(0.0, 1.0);
    final color = _getRingColor();

    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, r, paint);

    // Dot accents
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi + breathPhase * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      final dotPaint = Paint()
        ..color = color.withValues(alpha: i % 3 == 0 ? 0.8 : 0.2);
      canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 2.5 : 1.5, dotPaint);
    }
  }

  Color _getRingColor() {
    switch (state) {
      case state_model.AvatarState.listening:
        return AppColors.micActive;
      case state_model.AvatarState.thinking:
        return AppColors.secondary;
      case state_model.AvatarState.speaking:
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.state != state || old.breathPhase != breathPhase;
}

// ── Pulsing Dot ───────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
