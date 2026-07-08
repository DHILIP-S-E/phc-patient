import 'package:flutter/material.dart';

/// Displays `assets/images/<assetName>` and falls back to a soft gradient
/// placeholder (with an icon) whenever that file hasn't been supplied yet.
/// Drop a matching image into assets/images/ and hot-restart to see it.
class AppPhoto extends StatelessWidget {
  final String assetName;
  final IconData placeholderIcon;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const AppPhoto({
    super.key,
    required this.assetName,
    this.placeholderIcon = Icons.image_outlined,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        'assets/images/$assetName',
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDBEAFE), Color(0xFFCCFBF1)],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(placeholderIcon, size: 32, color: const Color(0xFF2563EB).withOpacity(0.5)),
    );
  }
}

/// Circular avatar version of [AppPhoto], for patient/doctor/chef avatars.
class AppAvatar extends StatelessWidget {
  final String assetName;
  final double radius;
  final String fallbackInitials;

  const AppAvatar({
    super.key,
    required this.assetName,
    this.radius = 20,
    this.fallbackInitials = '',
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.asset(
          'assets/images/$assetName',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF2563EB),
            alignment: Alignment.center,
            child: Text(
              fallbackInitials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.7,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
