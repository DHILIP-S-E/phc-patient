import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../data/models/ncd_tb_models.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// The current patient's NCD (non-communicable disease) screening history
/// (GET /patients/me/ncd). Self-contained to this screen — watches
/// [authProvider] the same way `profileProvider` does so it naturally
/// refetches on login.
final _ncdHistoryProvider = FutureProvider.autoDispose<List<NcdScreeningItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return [];
  return ref.read(patientPortalRepositoryProvider).getNcdHistory();
});

/// NCD screening dashboard: a referral banner (if the latest screening was
/// flagged), a risk-level summary for the latest reading, and a full
/// screening history timeline.
class NcdDashboard extends ConsumerWidget {
  const NcdDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ncdAsync = ref.watch(_ncdHistoryProvider);

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
                  Text('NCD Screening', style: AppText.sectionTitle()),
                ],
              ),
            ),
            Expanded(
              child: ncdAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Could not load NCD screening data. Please try again later.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                  ),
                ),
                data: (history) => history.isEmpty
                    ? const _EmptyNcdState()
                    : _NcdContent(history: history, onRefresh: () => ref.refresh(_ncdHistoryProvider.future)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NcdContent extends StatelessWidget {
  final List<NcdScreeningItem> history;
  final Future<void> Function() onRefresh;

  const _NcdContent({required this.history, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final sorted = [...history]..sort((a, b) => b.screeningDate.compareTo(a.screeningDate));
    final latest = sorted.first;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          if (latest.referralFlag) ...[
            const _ReferralBanner(),
            const SizedBox(height: 16),
          ],
          _LatestReadingCard(item: latest),
          const SizedBox(height: 24),
          Text('Screening History', style: AppText.sectionTitle()),
          const SizedBox(height: 12),
          for (int i = 0; i < sorted.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NcdScreeningTile(item: sorted[i]),
            ),
        ],
      ),
    );
  }
}

class _ReferralBanner extends StatelessWidget {
  const _ReferralBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your latest screening was flagged for referral — please follow up with your ASHA or facility.',
              style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestReadingCard extends StatelessWidget {
  final NcdScreeningItem item;

  const _LatestReadingCard({required this.item});

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
              const AppIcon(name: 'heart_pulse', fallback: Icons.monitor_heart_outlined, size: 36, color: Colors.white),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest Screening',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.screeningDate) ?? 'Not recorded',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              _RiskLevelBadge(riskLevel: item.riskLevel, solid: true),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _HeroStat(label: 'BP', value: _formatBp(item.bpSystolic, item.bpDiastolic))),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _HeroStat(
                  label: 'Blood Sugar',
                  value: item.bloodSugarMgdl != null ? '${item.bloodSugarMgdl!.toStringAsFixed(0)} mg/dL' : '-',
                ),
              ),
              Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _HeroStat(label: 'BMI', value: item.bmi != null ? item.bmi!.toStringAsFixed(1) : '-'),
              ),
            ],
          ),
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

class _NcdScreeningTile extends StatelessWidget {
  final NcdScreeningItem item;

  const _NcdScreeningTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_formatDate(item.screeningDate) ?? '-', style: AppText.sectionTitle()),
              const Spacer(),
              _RiskLevelBadge(riskLevel: item.riskLevel, solid: false),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _VisitMetric(label: 'BP', value: _formatBp(item.bpSystolic, item.bpDiastolic))),
              Expanded(
                child: _VisitMetric(
                  label: 'Blood Sugar',
                  value: item.bloodSugarMgdl != null ? '${item.bloodSugarMgdl!.toStringAsFixed(0)} mg/dL' : '-',
                ),
              ),
              Expanded(
                child: _VisitMetric(label: 'BMI', value: item.bmi != null ? item.bmi!.toStringAsFixed(1) : '-'),
              ),
            ],
          ),
          if (item.referralFlag) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.hairline),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Color(0xFFDC2626)),
                SizedBox(width: 6),
                Text(
                  'Flagged for referral',
                  style: TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
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

/// Colored badge for `risk_level` ("LOW" | "MODERATE" | "HIGH"), case
/// insensitive. [solid] renders a white-on-color badge for use on the
/// gradient hero card; otherwise a soft tinted badge for use on white cards.
class _RiskLevelBadge extends StatelessWidget {
  final String? riskLevel;
  final bool solid;

  const _RiskLevelBadge({required this.riskLevel, required this.solid});

  @override
  Widget build(BuildContext context) {
    final level = riskLevel?.toUpperCase();
    final color = _colorFor(level);
    final label = level ?? 'UNKNOWN';

    if (solid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Color _colorFor(String? level) {
    switch (level) {
      case 'LOW':
        return const Color(0xFF10B981);
      case 'MODERATE':
        return const Color(0xFFD97706);
      case 'HIGH':
        return const Color(0xFFDC2626);
      default:
        return AppColors.muted;
    }
  }
}

class _EmptyNcdState extends StatelessWidget {
  const _EmptyNcdState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(name: 'heart_pulse', fallback: Icons.monitor_heart_outlined, size: 56, color: AppColors.muted),
            const SizedBox(height: 16),
            Text('No NCD screenings on file', style: AppText.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Once your ASHA or facility records an NCD screening, it will show up here.',
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
