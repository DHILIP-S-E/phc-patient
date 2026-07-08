import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app_icon.dart';
import '../data/models/clinical_models.dart';
import '../data/models/visit_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';

/// Which portal endpoint a merged timeline row came from — drives icon +
/// label choice in [_TimelineCard].
enum _RecordKind { visit, referral, labTest }

/// One row in the merged Visits + Referrals + Lab Tests timeline.
class _TimelineEntry {
  final _RecordKind kind;
  final String title;
  final String subtitle;
  final String status;
  final DateTime sortDate;
  final String? displayDate;

  const _TimelineEntry({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.sortDate,
    required this.displayDate,
  });
}

/// Merges GET /patients/me/visits, /referrals and /lab-tests into one
/// reverse-chronological timeline (visit_date / referred_at / completed_at
/// respectively). Local to this screen — nothing else needs the merged
/// shape, so it isn't promoted to state/.
final _healthRecordsProvider = FutureProvider.autoDispose<List<_TimelineEntry>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return [];
  final repo = ref.read(patientPortalRepositoryProvider);

  final results = await Future.wait([repo.getVisits(), repo.getReferrals(), repo.getLabTests()]);
  final visits = results[0] as List<VisitItem>;
  final referrals = results[1] as List<ReferralItem>;
  final labTests = results[2] as List<LabTestItem>;

  final entries = <_TimelineEntry>[
    for (final v in visits)
      _TimelineEntry(
        kind: _RecordKind.visit,
        title: 'Visit · ${_titleCase(v.visitType)}',
        subtitle: 'OP #${v.opNumber}',
        status: v.status,
        sortDate: _parseDate(v.visitDate),
        displayDate: v.visitDate,
      ),
    for (final r in referrals)
      _TimelineEntry(
        kind: _RecordKind.referral,
        title: 'Referral to Facility #${r.toFacilityId}',
        subtitle: (r.reason != null && r.reason!.trim().isNotEmpty) ? r.reason! : 'No reason recorded',
        status: r.status,
        sortDate: _parseDate(r.referredAt),
        displayDate: r.referredAt,
      ),
    for (final l in labTests)
      _TimelineEntry(
        kind: _RecordKind.labTest,
        title: 'Lab Test #${l.testId}',
        subtitle: (l.resultValue != null && l.resultValue!.trim().isNotEmpty)
            ? 'Result: ${l.resultValue}${l.unit != null ? ' ${l.unit}' : ''}'
            : 'No result yet',
        status: l.status,
        // Lab tests have no "created" timestamp on the wire, only
        // completed_at (nullable until the result is in) — entries without
        // one sink to the bottom of the reverse-chronological list.
        sortDate: _parseDate(l.completedAt),
        displayDate: l.completedAt,
      ),
  ];

  entries.sort((a, b) => b.sortDate.compareTo(a.sortDate));
  return entries;
});

DateTime _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
  return DateTime.tryParse(raw) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

String _titleCase(String raw) {
  return raw
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0]}${w.substring(1).toLowerCase()}')
      .join(' ');
}

String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return 'Date unknown';
  // Backend dates are ISO strings — a plain substring is enough for display.
  return raw.length >= 10 ? raw.substring(0, 10) : raw;
}

class _KindVisuals {
  final String iconName;
  final IconData fallback;
  final Color color;
  final String label;

  const _KindVisuals(this.iconName, this.fallback, this.color, this.label);
}

_KindVisuals _visualsFor(_RecordKind kind) {
  switch (kind) {
    case _RecordKind.visit:
      return const _KindVisuals('stethoscope', Icons.medical_services_outlined, AppColors.primary, 'Visit');
    case _RecordKind.referral:
      return const _KindVisuals('health_worker', Icons.compare_arrows, AppColors.teal, 'Referral');
    case _RecordKind.labTest:
      return const _KindVisuals('droplet', Icons.science_outlined, Color(0xFFF59E0B), 'Lab Test');
  }
}

/// Buckets the many VisitStatus / ReferralStatus / LabTestStatus wire values
/// into a small set of badge colors by keyword rather than an exhaustive
/// switch (the three enums don't share a type).
Color _statusColor(String status) {
  final s = status.toUpperCase();
  if (s.contains('CANCEL') || s.contains('REJECT') || s.contains('NO_SHOW')) {
    return const Color(0xFFEF4444);
  }
  if (s == 'COMPLETED' || s == 'VERIFIED' || s == 'REPORT_ISSUED' || s == 'ACCEPTED') {
    return const Color(0xFF10B981);
  }
  if (s == 'PENDING' || s == 'WAITING') {
    return AppColors.muted;
  }
  return const Color(0xFFF59E0B);
}

/// Merges GET /patients/me/visits, /referrals and /lab-tests into a single
/// reverse-chronological timeline, one card per entry.
class HealthRecordsScreen extends ConsumerWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(_healthRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text(
          'Health Records',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        child: records.when(
          data: (entries) {
            if (entries.isEmpty) {
              return const _EmptyState();
            }
            return RefreshIndicator(
              onRefresh: () => ref.refresh(_healthRecordsProvider.future),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _TimelineCard(entry: entries[index]),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load health records.\n$err',
                textAlign: TextAlign.center,
                style: AppText.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final _TimelineEntry entry;

  const _TimelineCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final visuals = _visualsFor(entry.kind);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: visuals.color.withOpacity(0.12), shape: BoxShape.circle),
            child: AppIcon(name: visuals.iconName, fallback: visuals.fallback, color: visuals.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: entry.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(entry.subtitle, style: AppText.body),
                const SizedBox(height: 6),
                Text(_formatDate(entry.displayDate), style: AppText.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
      child: Text(
        _titleCase(status),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(name: 'stethoscope', fallback: Icons.folder_open, size: 48, opacity: 0.5),
            const SizedBox(height: 16),
            Text('No health records yet', style: AppText.sectionTitle()),
            const SizedBox(height: 6),
            Text(
              'Visits, referrals and lab tests will show up here once recorded.',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
          ],
        ),
      ),
    );
  }
}
