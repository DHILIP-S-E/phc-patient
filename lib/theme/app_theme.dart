import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/app_icon.dart';

/// Shared palette + text styles matching the GramCare patient reference
/// mockups: serif display headlines over a clean sans body, soft blue/teal
/// gradients, and near-black CTA buttons.
class AppColors {
  static const ink = Color(0xFF1E293B);
  static const inkSoft = Color(0xFF64748B);
  static const muted = Color(0xFF94A3B8);
  static const primary = Color(0xFF2563EB);
  static const teal = Color(0xFF0D9488);
  static const canvas = Color(0xFFF1F5F9);
  static const surface = Color(0xFFF8FAFC);
  static const hairline = Color(0xFFF1F5F9);
  static const cta = Color(0xFF111827);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF60A5FA), Color(0xFF5EEAD4)],
  );
}

class AppText {
  static TextStyle display({double size = 26, Color color = AppColors.ink}) =>
      GoogleFonts.playfairDisplay(fontSize: size, fontWeight: FontWeight.w600, color: color, height: 1.15);

  static TextStyle sectionTitle({Color color = AppColors.ink}) =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink).copyWith(color: color);

  static const label = TextStyle(fontSize: 12, color: AppColors.inkSoft);
  static const caption = TextStyle(fontSize: 11, color: AppColors.muted);
  static const body = TextStyle(fontSize: 13, color: AppColors.inkSoft, height: 1.5);
}

/// Reusable frosted-white icon button used in page headers throughout the app.
/// Pass [iconName] to use a 3D icon asset; falls back to the flat [icon].
class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String? iconName;
  final VoidCallback? onTap;

  const HeaderIconButton({super.key, required this.icon, this.iconName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: iconName != null
            ? AppIcon(name: iconName!, fallback: icon, size: 20)
            : Icon(icon, color: AppColors.inkSoft),
      ),
    );
  }
}

/// Rounded near-black call-to-action button matching the "Get started" /
/// "Book now" buttons in the reference mockups.
class DarkCtaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const DarkCtaButton({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
