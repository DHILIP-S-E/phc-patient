import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../state/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../emergency_screen.dart';
import '../health_records_screen.dart';
import '../queue_screen.dart';
import 'child_dashboard.dart';
import 'general_adult_dashboard.dart';
import 'ncd_dashboard.dart';
import 'pregnancy_dashboard.dart';
import 'tb_dashboard.dart';

/// Root of the authenticated app. The "Home" tab renders one of the
/// category-specific dashboards based on `GET /patients/me/profile`'s
/// `category` — this IS the adaptive-dashboard mechanism the whole platform
/// is built around. Falls back to [GeneralAdultDashboard] while loading, on
/// error, or for any unrecognized category, so the app is never blank.
class AdaptiveDashboardShell extends ConsumerStatefulWidget {
  const AdaptiveDashboardShell({super.key});

  @override
  ConsumerState<AdaptiveDashboardShell> createState() => _AdaptiveDashboardShellState();
}

class _AdaptiveDashboardShellState extends ConsumerState<AdaptiveDashboardShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _NavItem(iconName: 'house', fallback: Icons.home_outlined, label: 'Home'),
    _NavItem(iconName: 'stethoscope', fallback: Icons.folder_shared_outlined, label: 'Records'),
    _NavItem(iconName: 'calendar', fallback: Icons.confirmation_number_outlined, label: 'Queue'),
    _NavItem(iconName: 'heart', fallback: Icons.emergency_outlined, label: 'Emergency'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeTab(),
      const HealthRecordsScreen(),
      const QueueScreen(),
      const EmergencyScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < _tabs.length; i++)
              GestureDetector(
                onTap: () => setState(() => _currentIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _currentIndex == i ? AppColors.cta : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AppIcon(
                    name: _tabs[i].iconName,
                    fallback: _tabs[i].fallback,
                    color: _currentIndex == i ? Colors.white : AppColors.muted,
                    size: 24,
                    opacity: _currentIndex == i ? 1.0 : 0.55,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String iconName;
  final IconData fallback;
  final String label;

  const _NavItem({required this.iconName, required this.fallback, required this.label});
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => const GeneralAdultDashboard(),
      data: (profile) {
        if (profile == null) return const GeneralAdultDashboard();
        switch (profile.category) {
          case 'pregnant':
            return const PregnancyDashboard();
          case 'child':
            return const ChildDashboard();
          case 'ncd':
            return const NcdDashboard();
          case 'tb':
            return const TbDashboard();
          case 'senior':
            return const GeneralAdultDashboard(isSenior: true);
          default:
            return const GeneralAdultDashboard();
        }
      },
    );
  }
}
