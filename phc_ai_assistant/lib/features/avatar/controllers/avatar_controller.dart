// ============================================================
// PHC AI Assistant - Avatar Controller
// Controls avatar state machine and animation transitions
// ============================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/avatar_state.dart' as state_model;

class AvatarController extends ChangeNotifier {
  state_model.AvatarState _avatarState = state_model.AvatarState.idle;
  state_model.AvatarEmotion _emotion = state_model.AvatarEmotion.neutral;
  state_model.AvatarConfig _config = const state_model.AvatarConfig();

  double _mouthOpenness = 0.0; // 0.0 - 1.0 for lip sync
  bool _isBlinking = false;
  double _headTilt = 0.0;   // -1.0 to 1.0
  double _headNod = 0.0;    // 0.0 to 1.0
  double _breathPhase = 0.0; // 0.0 - 2π for breathing animation

  Timer? _idleTimer;
  Timer? _blinkTimer;
  Timer? _lipSyncTimer;

  state_model.AvatarState get avatarState => _avatarState;
  state_model.AvatarEmotion get emotion => _emotion;
  state_model.AvatarConfig get config => _config;
  double get mouthOpenness => _mouthOpenness;
  bool get isBlinking => _isBlinking;
  double get headTilt => _headTilt;
  double get headNod => _headNod;
  double get breathPhase => _breathPhase;

  AvatarController() {
    _startIdleAnimation();
    _startBlinkTimer();
  }

  // ── State Transitions ─────────────────────────────────────

  void setIdle() {
    _avatarState = state_model.AvatarState.idle;
    _emotion = state_model.AvatarEmotion.neutral;
    _mouthOpenness = 0.0;
    _headTilt = 0.0;
    _startIdleAnimation();
    notifyListeners();
  }

  void setListening() {
    _avatarState = state_model.AvatarState.listening;
    _emotion = state_model.AvatarEmotion.neutral;
    _headTilt = -0.15; // Slight lean toward mic
    _mouthOpenness = 0.0;
    notifyListeners();
  }

  void setThinking() {
    _avatarState = state_model.AvatarState.thinking;
    _emotion = state_model.AvatarEmotion.thinking;
    _headTilt = 0.2; // Head tilt right while thinking
    _mouthOpenness = 0.05;
    notifyListeners();
  }

  void setSpeaking() {
    _avatarState = state_model.AvatarState.speaking;
    _emotion = state_model.AvatarEmotion.happy;
    _headTilt = 0.0;
    _startLipSync();
    notifyListeners();
  }

  void setGreeting() {
    _avatarState = state_model.AvatarState.greeting;
    _emotion = state_model.AvatarEmotion.happy;
    _headNod = 1.0;
    notifyListeners();
    // Auto-return to idle after greeting
    Future.delayed(const Duration(seconds: 2), () {
      if (_avatarState == state_model.AvatarState.greeting) setIdle();
    });
  }

  void setEmotion(state_model.AvatarEmotion emotion) {
    _emotion = emotion;
    notifyListeners();
  }

  void updateConfig(state_model.AvatarConfig config) {
    _config = config;
    notifyListeners();
  }

  // ── Lip Sync ─────────────────────────────────────────────

  void _startLipSync() {
    _lipSyncTimer?.cancel();
    // Simulate natural lip sync with phoneme-like variation
    int tick = 0;
    _lipSyncTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (_avatarState != state_model.AvatarState.speaking) {
        _lipSyncTimer?.cancel();
        _mouthOpenness = 0.0;
        notifyListeners();
        return;
      }
      // Natural mouth movement pattern
      final patterns = [0.6, 0.3, 0.8, 0.1, 0.7, 0.4, 0.9, 0.2, 0.5, 0.0];
      _mouthOpenness = patterns[tick % patterns.length];
      tick++;
      notifyListeners();
    });
  }

  void stopSpeaking() {
    _lipSyncTimer?.cancel();
    _mouthOpenness = 0.0;
    if (_avatarState == state_model.AvatarState.speaking) {
      setIdle();
    }
  }

  // ── Idle Animation ────────────────────────────────────────

  void _startIdleAnimation() {
    _idleTimer?.cancel();
    double phase = 0;
    _idleTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_avatarState != state_model.AvatarState.idle) {
        _idleTimer?.cancel();
        return;
      }
      phase += 0.05;
      _breathPhase = phase;
      // Subtle head drift
      _headTilt = 0.05 * (0.5 - (phase % (2 * 3.14159)).abs() / 3.14159);
      notifyListeners();
    });
  }

  // ── Blink Timer ───────────────────────────────────────────

  void _startBlinkTimer() {
    _scheduleBlink();
  }

  void _scheduleBlink() {
    // Random blink interval: 2-5 seconds
    final delay = Duration(
      milliseconds: 2000 + (DateTime.now().millisecondsSinceEpoch % 3000),
    );
    _blinkTimer = Timer(delay, () async {
      _isBlinking = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 150));
      _isBlinking = false;
      notifyListeners();
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _blinkTimer?.cancel();
    _lipSyncTimer?.cancel();
    super.dispose();
  }
}
