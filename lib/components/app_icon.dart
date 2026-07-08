import 'package:flutter/material.dart';

/// Renders a glossy 3D icon from `assets/icons/<name>.png` (Microsoft Fluent
/// Emoji 3D set, MIT licensed — see assets/icons/LICENSE_NOTICE.md) and
/// falls back to a flat Material icon if that asset is missing.
///
/// 3D icons are pre-rendered in full color, so [color] only applies to the
/// Material fallback, never to the image.
class AppIcon extends StatelessWidget {
  final String name;
  final IconData fallback;
  final double size;
  final Color? color;
  final double opacity;

  const AppIcon({
    super.key,
    required this.name,
    required this.fallback,
    this.size = 24,
    this.color,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        'assets/icons/$name.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(fallback, size: size, color: color),
      ),
    );
  }
}
