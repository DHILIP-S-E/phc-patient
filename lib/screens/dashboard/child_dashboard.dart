import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../data/models/child_models.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// The current patient's child record (GET /patients/me/child), including
/// growth history and vaccination schedule/records. Watches [authProvider]
/// the same way `profileProvider` does; returns `null` whenever there's no
/// authenticated patient, and legitimately returns `null` for a patient with
/// no child record (the backend does the same).
final childDetailProvider = FutureProvider<ChildDetail?>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return null;
  return ref.read(patientPortalRepositoryProvider).getChild();
});

/// Child health dashboard: birth info, growth records (weight/height/MUAC
/// with malnutrition flags), and a combined vaccination timeline
/// (schedule + administered records).
class ChildDashboard extends ConsumerWidget {
  const ChildDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childDetailProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  Text('Child Health', style: AppText.sectionTitle()),
                ],
              ),
            ),
            Expanded(
              child: childAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Could not load child health data. Please try again later.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                  ),
                ),
                data: (child) => child == null ? const _EmptyChildState() : _ChildContent(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChildState extends StatelessWidget {
  const _EmptyChildState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(name: 'baby', fallback: Icons.child_care, size: 56, color: AppColors.muted),
            const SizedBox(height: 16),
            Text('No child record found', style: AppText.sectionTitle()),
            const SizedBox(height: 8),
            Text(
              'Growth records and vaccinations will appear here once a child health record is created for you.',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildContent extends StatelessWidget {
  final ChildDetail child;

  const _ChildContent({required this.child});

  @override
  Widget build(BuildContext context) {
    final entries = _buildTimeline(child);
    final growthRecords = [...child.growthRecords]
      ..sort((a, b) => b.recordDate.compareTo(a.recordDate));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BirthInfoCard(child: child),
          const SizedBox(height: 24),

          Text('Growth Records', style: AppText.sectionTitle()),
          const SizedBox(height: 12),
          if (growthRecords.isEmpty)
            _NoDataCard(text: 'No growth records yet.')
          else
            ...growthRecords.map(
              (record) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GrowthRecordCard(record: record),
              ),
            ),
          const SizedBox(height: 24),

          Text('Vaccinations', style: AppText.sectionTitle()),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            _NoDataCard(text: 'No vaccination schedule yet.')
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _VaccinationTile(entry: entry),
              ),
            ),
        ],
      ),
    );
  }

  /// Combines [ChildDetail.vaccinationSchedule] with
  /// [ChildDetail.vaccinationRecords] into one timeline: a schedule item is
  /// shown as done (using the administered date) if a matching record
  /// exists (same vaccine name, and same dose number when both specify one);
  /// otherwise it's shown with its own PENDING/DUE/OVERDUE/MISSED status.
  /// Administered records with no matching schedule item (e.g. catch-up
  /// doses) are appended as standalone "recorded" entries.
  List<_TimelineEntry> _buildTimeline(ChildDetail child) {
    final unmatchedRecords = [...child.vaccinationRecords];
    final entries = <_TimelineEntry>[];

    for (final schedule in child.vaccinationSchedule) {
      final matchIndex = unmatchedRecords.indexWhere(
        (record) =>
            record.vaccineName == schedule.vaccineName &&
            (schedule.doseNumber == null ||
                record.doseNumber == null ||
                record.doseNumber == schedule.doseNumber),
      );

      if (matchIndex != -1) {
        final record = unmatchedRecords.removeAt(matchIndex);
        entries.add(
          _TimelineEntry(
            vaccineName: schedule.vaccineName,
            doseNumber: schedule.doseNumber ?? record.doseNumber,
            date: record.administeredDate,
            label: 'Administered',
            color: const Color(0xFF10B981),
            icon: Icons.check_circle,
          ),
        );
      } else {
        entries.add(
          _TimelineEntry(
            vaccineName: schedule.vaccineName,
            doseNumber: schedule.doseNumber,
            date: schedule.scheduledDate,
            label: _statusLabel(schedule.status),
            color: _statusColor(schedule.status),
            icon: _statusIcon(schedule.status),
          ),
        );
      }
    }

    // Administered doses with no corresponding schedule entry.
    for (final record in unmatchedRecords) {
      entries.add(
        _TimelineEntry(
          vaccineName: record.vaccineName,
          doseNumber: record.doseNumber,
          date: record.administeredDate,
          label: 'Administered',
          color: const Color(0xFF10B981),
          icon: Icons.check_circle,
        ),
      );
    }

    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'DUE':
        return 'Due';
      case 'OVERDUE':
        return 'Overdue';
      case 'COMPLETED':
        return 'Completed';
      case 'MISSED':
        return 'Missed';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.muted;
      case 'DUE':
        return const Color(0xFFD97706);
      case 'OVERDUE':
        return const Color(0xFFDC2626);
      case 'COMPLETED':
        return const Color(0xFF10B981);
      case 'MISSED':
        return const Color(0xFFDC2626);
      default:
        return AppColors.muted;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule;
      case 'DUE':
        return Icons.notifications_active_outlined;
      case 'OVERDUE':
        return Icons.warning_amber_rounded;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'MISSED':
        return Icons.event_busy;
      default:
        return Icons.schedule;
    }
  }
}

class _TimelineEntry {
  final String vaccineName;
  final int? doseNumber;
  final String date;
  final String label;
  final Color color;
  final IconData icon;

  const _TimelineEntry({
    required this.vaccineName,
    required this.doseNumber,
    required this.date,
    required this.label,
    required this.color,
    required this.icon,
  });
}

class _BirthInfoCard extends StatelessWidget {
  final ChildDetail child;

  const _BirthInfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
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
          const AppIcon(name: 'baby', fallback: Icons.child_care, size: 44, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Birth Details',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(child.birthDate),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(child.deliveryType == null ? 'Delivery type not recorded' : 'Delivery: ${child.deliveryType}'),
                    if (child.isHighPriority) _pill('High priority', background: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, {Color? background}) {
    final isSolid = background != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSolid ? const Color(0xFFDC2626) : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return 'Not recorded';
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }
}

class _GrowthRecordCard extends StatelessWidget {
  final GrowthRecordItem record;

  const _GrowthRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final flags = <String>[
      if (record.isUnderweight) 'Underweight',
      if (record.isStunted) 'Stunted',
      if (record.isWasted) 'Wasted',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.recordDate.length >= 10 ? record.recordDate.substring(0, 10) : record.recordDate,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statBlock(
                  iconName: 'weight',
                  fallback: Icons.monitor_weight_outlined,
                  value: record.weightKg == null ? '—' : '${record.weightKg!.toStringAsFixed(1)} kg',
                  label: 'Weight',
                  color: const Color(0xFF2563EB),
                  background: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statBlock(
                  iconName: 'height',
                  fallback: Icons.height,
                  value: record.heightCm == null ? '—' : '${record.heightCm!.toStringAsFixed(1)} cm',
                  label: 'Height',
                  color: const Color(0xFF0D9488),
                  background: const Color(0xFFF0FDFA),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statBlock(
                  iconName: 'ruler',
                  fallback: Icons.straighten,
                  value: record.muacCm == null ? '—' : '${record.muacCm!.toStringAsFixed(1)} cm',
                  label: 'MUAC',
                  color: const Color(0xFFD97706),
                  background: const Color(0xFFFFF7ED),
                ),
              ),
            ],
          ),
          if (flags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: flags
                  .map(
                    (flag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        flag,
                        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBlock({
    required String iconName,
    required IconData fallback,
    required String value,
    required String label,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          AppIcon(name: iconName, fallback: fallback, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.ink)),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption),
        ],
      ),
    );
  }
}

class _VaccinationTile extends StatelessWidget {
  final _TimelineEntry entry;

  const _VaccinationTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = entry.date.length >= 10 ? entry.date.substring(0, 10) : entry.date;
    final doseText = entry.doseNumber == null ? '' : ' · Dose ${entry.doseNumber}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: entry.color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(entry.icon, color: entry.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.vaccineName}$doseText',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink),
                ),
                const SizedBox(height: 2),
                Text(date, style: AppText.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: entry.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Text(
              entry.label,
              style: TextStyle(color: entry.color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoDataCard extends StatelessWidget {
  final String text;

  const _NoDataCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: AppText.body),
    );
  }
}
