import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app_icon.dart';
import '../data/models/clinical_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';

/// GET /patients/me/lab-tests. Local to this screen — nothing else needs
/// the raw list, so it isn't promoted to state/.
final _labTestsProvider = FutureProvider.autoDispose<List<LabTestItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return [];
  return ref.read(patientPortalRepositoryProvider).getLabTests();
});

/// Module 12 (Laboratory Management) status colors: green once a result is
/// verified/issued, amber while in progress, grey while pending, red if
/// cancelled. See `phc_api/models/enums.py::LabTestStatus`.
Color _statusColor(String status) {
  switch (status.toUpperCase()) {
    case 'VERIFIED':
    case 'REPORT_ISSUED':
      return const Color(0xFF10B981);
    case 'SAMPLE_COLLECTED':
    case 'PROCESSING':
    case 'COMPLETED':
      return const Color(0xFFF59E0B);
    case 'CANCELLED':
      return const Color(0xFFEF4444);
    case 'PENDING':
    default:
      return AppColors.muted;
  }
}

String _titleCase(String raw) {
  return raw
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0]}${w.substring(1).toLowerCase()}')
      .join(' ');
}

String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  // Backend dates are ISO strings — a plain substring is enough for display.
  return raw.length >= 10 ? raw.substring(0, 10) : raw;
}

/// Lists every lab test ordered for the patient (GET /patients/me/lab-tests),
/// newest-completed first, with a color-coded status badge and the
/// result/unit/reference-range when the backend has them.
class LaboratoryScreen extends ConsumerWidget {
  const LaboratoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(_labTestsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text(
          'Laboratory',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        child: tests.when(
          data: (items) {
            if (items.isEmpty) {
              return const _EmptyState();
            }
            final sorted = [...items]
              ..sort((a, b) => (b.completedAt ?? '').compareTo(a.completedAt ?? ''));
            return RefreshIndicator(
              onRefresh: () => ref.refresh(_labTestsProvider.future),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: sorted.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _LabTestCard(test: sorted[index]),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load lab tests.\n$err',
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

class _LabTestCard extends StatelessWidget {
  final LabTestItem test;

  const _LabTestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final hasResult = test.resultValue != null && test.resultValue!.trim().isNotEmpty;
    final hasRange = test.referenceRange != null && test.referenceRange!.trim().isNotEmpty;
    final hasNotes = test.resultNotes != null && test.resultNotes!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.12), shape: BoxShape.circle),
                child: const AppIcon(name: 'droplet', fallback: Icons.science_outlined, color: AppColors.teal, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Test #${test.testId}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: test.status),
            ],
          ),
          if (hasResult || hasRange || hasNotes) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.hairline),
            const SizedBox(height: 14),
            if (hasResult)
              _ResultRow(
                label: 'Result',
                value: test.unit != null ? '${test.resultValue} ${test.unit}' : test.resultValue!,
              ),
            if (hasRange) ...[
              if (hasResult) const SizedBox(height: 8),
              _ResultRow(label: 'Reference range', value: test.referenceRange!),
            ],
            if (hasNotes) ...[
              if (hasResult || hasRange) const SizedBox(height: 8),
              _ResultRow(label: 'Notes', value: test.resultNotes!),
            ],
          ],
          if (test.completedAt != null) ...[
            const SizedBox(height: 10),
            Text('Completed ${_formatDate(test.completedAt)}', style: AppText.caption),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: AppText.label),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w600),
          ),
        ),
      ],
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
            const AppIcon(name: 'droplet', fallback: Icons.science_outlined, size: 48, opacity: 0.5),
            const SizedBox(height: 16),
            Text('No lab tests yet', style: AppText.sectionTitle()),
            const SizedBox(height: 6),
            Text(
              'Tests ordered for you will show up here with results once ready.',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
          ],
        ),
      ),
    );
  }
}
