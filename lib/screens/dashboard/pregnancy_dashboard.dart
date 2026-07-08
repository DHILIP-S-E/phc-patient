import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../data/models/pregnancy_models.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// The current patient's pregnancy record (GET /patients/me/pregnancy),
/// including ANC visit history. `null` means no active pregnancy on file.
/// Self-contained to this screen — watches [authProvider] the same way
/// `profileProvider` does so it naturally refetches on login.
final _pregnancyProvider = FutureProvider.autoDispose<PregnancyDetail?>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return null;
  return ref.read(patientPortalRepositoryProvider).getPregnancy();
});

/// Pregnancy dashboard: EDD hero card + high-risk banner, gravida/para
/// stats, risk-flag chips, and an ANC visit timeline.
class PregnancyDashboard extends ConsumerWidget {
  const PregnancyDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnancyAsync = ref.watch(_pregnancyProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        title: Text('Pregnancy Care', style: AppText.sectionTitle()),
        centerTitle: false,
      ),
      body: pregnancyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Could not load pregnancy details.', style: AppText.body),
        ),
        data: (pregnancy) {
          if (pregnancy == null) return const _EmptyPregnancyState();
          return RefreshIndicator(
            onRefresh: () => ref.refresh(_pregnancyProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _PregnancyHeroCard(pregnancy: pregnancy),
                const SizedBox(height: 16),
                _RiskFlagChips(pregnancy: pregnancy),
                const SizedBox(height: 24),
                Text('ANC Visit Timeline', style: AppText.sectionTitle()),
                const SizedBox(height: 12),
                if (pregnancy.ancVisits.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text('No ANC visits recorded yet.', style: AppText.body),
                  )
                else
                  _AncVisitTimeline(visits: pregnancy.ancVisits),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PregnancyHeroCard extends StatelessWidget {
  final PregnancyDetail pregnancy;

  const _PregnancyHeroCard({required this.pregnancy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIcon(name: 'pregnant', fallback: Icons.pregnant_woman, size: 36, color: Colors.white),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated Due Date',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(pregnancy.eddDate) ?? 'Not recorded',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _HeroStat(label: 'Gravida', value: pregnancy.gravida?.toString() ?? '-')),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _HeroStat(label: 'Para', value: pregnancy.para?.toString() ?? '-')),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _HeroStat(label: 'Status', value: pregnancy.status)),
            ],
          ),
          if (pregnancy.isHighPriority) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'High-risk pregnancy — please follow up with your ASHA/facility closely.',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _RiskFlagChips extends StatelessWidget {
  final PregnancyDetail pregnancy;

  const _RiskFlagChips({required this.pregnancy});

  @override
  Widget build(BuildContext context) {
    final flags = <String>[
      if (pregnancy.hasHighBp == true) 'High BP',
      if (pregnancy.hasDiabetes == true) 'Diabetes',
      if (pregnancy.hasSevereAnaemia == true) 'Severe Anaemia',
    ];
    if (flags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flags
          .map(
            (flag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 14, color: Color(0xFFDC2626)),
                  const SizedBox(width: 6),
                  Text(
                    flag,
                    style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AncVisitTimeline extends StatelessWidget {
  final List<AncVisitItem> visits;

  const _AncVisitTimeline({required this.visits});

  @override
  Widget build(BuildContext context) {
    final sorted = [...visits]..sort((a, b) => b.visitNumber.compareTo(a.visitNumber));

    return Column(
      children: [
        for (int i = 0; i < sorted.length; i++)
          _AncVisitTile(visit: sorted[i], isLast: i == sorted.length - 1),
      ],
    );
  }
}

class _AncVisitTile extends StatelessWidget {
  final AncVisitItem visit;
  final bool isLast;

  const _AncVisitTile({required this.visit, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: AppColors.hairline)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Visit ${visit.visitNumber}', style: AppText.sectionTitle()),
                        const Spacer(),
                        Text(_formatDate(visit.visitDate) ?? '-', style: AppText.label),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _VisitMetric(
                            label: 'BP',
                            value: _formatBp(visit.bpSystolic, visit.bpDiastolic),
                          ),
                        ),
                        Expanded(
                          child: _VisitMetric(
                            label: 'Weight',
                            value: visit.weightKg != null ? '${visit.weightKg!.toStringAsFixed(1)} kg' : '-',
                          ),
                        ),
                        Expanded(
                          child: _VisitMetric(
                            label: 'Hb',
                            value:
                                visit.hemoglobinGDl != null ? '${visit.hemoglobinGDl!.toStringAsFixed(1)} g/dL' : '-',
                          ),
                        ),
                      ],
                    ),
                    if (visit.nextVisitDueDate != null) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.hairline),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.event_outlined, size: 14, color: AppColors.inkSoft),
                          const SizedBox(width: 6),
                          Text(
                            'Next visit due: ${_formatDate(visit.nextVisitDueDate)}',
                            style: AppText.label,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitMetric extends StatelessWidget {
  final String label;
  final String value;

  const _VisitMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.caption),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
      ],
    );
  }
}

class _EmptyPregnancyState extends StatelessWidget {
  const _EmptyPregnancyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(name: 'pregnant', fallback: Icons.pregnant_woman, size: 56, color: AppColors.muted),
            const SizedBox(height: 16),
            Text('No active pregnancy record on file', style: AppText.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Once your ASHA or facility records a pregnancy, it will show up here.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String? _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return null;
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return iso;
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
}

String _formatBp(int? systolic, int? diastolic) {
  if (systolic == null || diastolic == null) return '-';
  return '$systolic/$diastolic';
}
