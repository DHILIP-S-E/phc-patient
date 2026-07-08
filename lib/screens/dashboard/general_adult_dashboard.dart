import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../state/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../emergency_screen.dart';
import '../health_records_screen.dart';
import '../laboratory_screen.dart';
import '../nearby_phc_screen.dart';
import '../notifications_screen.dart';
import '../queue_screen.dart';

/// Dashboard for the 'adult' and 'senior' patient profile categories.
///
/// There's no generic vitals/appointments backend yet for this cohort, so
/// this screen stays focused on what's real: a welcome header (from
/// [profileProvider]) and attractive quick-link navigation cards into the
/// screens that do exist (Health Records, Laboratory, Queue, Nearby PHCs,
/// Notifications, Emergency). Pass [isSenior] to slightly adjust the framing
/// copy and to show an extra "Elder Care" section.
class GeneralAdultDashboard extends ConsumerWidget {
  final bool isSenior;

  const GeneralAdultDashboard({super.key, this.isSenior = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(profileProvider),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _WelcomeHeader(
                isSenior: isSenior,
                name: profileAsync.maybeWhen(data: (profile) => profile?.name, orElse: () => null),
              ),
              const SizedBox(height: 24),
              Text('Quick Links', style: AppText.sectionTitle()),
              const SizedBox(height: 12),
              _QuickLinksGrid(isSenior: isSenior),
              if (isSenior) ...[
                const SizedBox(height: 24),
                Text('Elder Care', style: AppText.sectionTitle()),
                const SizedBox(height: 12),
                const _ElderCareCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final bool isSenior;
  final String? name;

  const _WelcomeHeader({required this.isSenior, required this.name});

  @override
  Widget build(BuildContext context) {
    final greeting = _greetingForHour(DateTime.now().hour);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(
            name: isSenior ? 'person' : 'health_worker',
            fallback: isSenior ? Icons.elderly : Icons.favorite_border,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  name ?? 'Welcome back',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  isSenior
                      ? 'Here’s a quick look at your health services and elder care support.'
                      : 'Here’s a quick look at your health services.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _QuickLinksGrid extends StatelessWidget {
  final bool isSenior;

  const _QuickLinksGrid({required this.isSenior});

  @override
  Widget build(BuildContext context) {
    final links = <_QuickLinkData>[
      _QuickLinkData(
        title: 'Health Records',
        subtitle: 'Visits & history',
        iconName: 'stethoscope',
        fallbackIcon: Icons.medical_information_outlined,
        color: const Color(0xFF2563EB),
        background: const Color(0xFFEFF6FF),
        screenBuilder: (_) => const HealthRecordsScreen(),
      ),
      _QuickLinkData(
        title: 'Laboratory',
        subtitle: 'Test results',
        iconName: 'droplet',
        fallbackIcon: Icons.biotech_outlined,
        color: const Color(0xFF0D9488),
        background: const Color(0xFFF0FDFA),
        screenBuilder: (_) => const LaboratoryScreen(),
      ),
      _QuickLinkData(
        title: 'Queue Status',
        subtitle: 'Live token status',
        iconName: 'calendar',
        fallbackIcon: Icons.confirmation_number_outlined,
        color: const Color(0xFFD97706),
        background: const Color(0xFFFFF7ED),
        screenBuilder: (_) => const QueueScreen(),
      ),
      _QuickLinkData(
        title: 'Nearby PHCs',
        subtitle: 'Find facilities',
        iconName: 'house',
        fallbackIcon: Icons.local_hospital_outlined,
        color: const Color(0xFF16A34A),
        background: const Color(0xFFF0FDF4),
        screenBuilder: (_) => const NearbyPhcScreen(),
      ),
      _QuickLinkData(
        title: 'Notifications',
        subtitle: 'Updates & alerts',
        iconName: 'bell',
        fallbackIcon: Icons.notifications_outlined,
        color: const Color(0xFF7C3AED),
        background: const Color(0xFFF5F3FF),
        screenBuilder: (_) => const NotificationsScreen(),
      ),
      _QuickLinkData(
        title: 'Emergency',
        subtitle: 'Get help fast',
        iconName: 'heart',
        fallbackIcon: Icons.emergency_outlined,
        color: const Color(0xFFDC2626),
        background: const Color(0xFFFEF2F2),
        screenBuilder: (_) => const EmergencyScreen(),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: links.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => _QuickLinkCard(data: links[index]),
    );
  }
}

class _QuickLinkData {
  final String title;
  final String subtitle;
  final String iconName;
  final IconData fallbackIcon;
  final Color color;
  final Color background;
  final WidgetBuilder screenBuilder;

  const _QuickLinkData({
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.fallbackIcon,
    required this.color,
    required this.background,
    required this.screenBuilder,
  });
}

class _QuickLinkCard extends StatelessWidget {
  final _QuickLinkData data;

  const _QuickLinkCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: data.screenBuilder)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: data.background, shape: BoxShape.circle),
              child: AppIcon(name: data.iconName, fallback: data.fallbackIcon, color: data.color, size: 24),
            ),
            const Spacer(),
            Text(
              data.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink),
            ),
            const SizedBox(height: 2),
            Text(data.subtitle, style: AppText.caption),
          ],
        ),
      ),
    );
  }
}

class _ElderCareCard extends StatelessWidget {
  const _ElderCareCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigator.push to a dedicated Elder Care support screen once
        // that flow exists and routing is wired up by the integration step.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elder Care support — coming soon'), duration: Duration(seconds: 1)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFF5F3FF), shape: BoxShape.circle),
              child: const AppIcon(name: 'person', fallback: Icons.elderly, color: Color(0xFF7C3AED), size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Elder Care Support',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Caretaker visits, mobility assistance and medication reminders tailored for seniors.',
                    style: AppText.body,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
