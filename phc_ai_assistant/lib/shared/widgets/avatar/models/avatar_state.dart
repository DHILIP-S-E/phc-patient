// ============================================================
// PHC AI Assistant - Avatar State
// ============================================================

enum AvatarEmotion {
  neutral,
  happy,
  concerned,
  thinking,
  surprised,
  empathetic,
}

enum AvatarState {
  idle,
  listening,
  thinking,
  speaking,
  greeting,
  nodding,
}

class AvatarConfig {
  final String gender; // 'male' | 'female'
  final bool showSubtitles;
  final double scale;

  const AvatarConfig({
    this.gender = 'female',
    this.showSubtitles = true,
    this.scale = 1.0,
  });

  AvatarConfig copyWith({
    String? gender,
    bool? showSubtitles,
    double? scale,
  }) {
    return AvatarConfig(
      gender: gender ?? this.gender,
      showSubtitles: showSubtitles ?? this.showSubtitles,
      scale: scale ?? this.scale,
    );
  }
}
