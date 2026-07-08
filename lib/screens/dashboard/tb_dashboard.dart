import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_icon.dart';
import '../../data/models/ncd_tb_models.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// The current patient's TB screening history (GET /patients/me/tb).
/// Self-contained to this screen — watches [authProvider] the same way
/// `profileProvider` does so it naturally refetches on login.
final _tbHistoryProvider = FutureProvider.autoDispose<List<TbScreeningItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return [];
  return ref.read(patientPortalRepositoryProvider).getTbHistory();
});

/// TB screening dashboard: an "under investigation" banner when the latest
/// screening is suspected, and a full screening history timeline.
class TbDashboard extends ConsumerWidget {
  const TbDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tbAsync = ref.watch(_tbHistoryProvider);

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
                  Text('TB Screening', style: AppText.sectionTitle()),
                ],
              ),
            ),
            Expanded(
              child: tbAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Could not load TB screening data. Please try again later.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                  ),
                ),
                data: (history) => history.isEmpty
                    ? const _EmptyTbState()
                    : _TbContent(history: history, onRefresh: () => ref.refresh(_tbHistoryProvider.future)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TbContent extends StatelessWidget {
  final List<TbScreeningItem> history;
  final Future<void> Function() onRefresh;

  const _TbContent({required this.history, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final sorted = [...history]..sort((a, b) => b.screeningDate.compareTo(a.screeningDate));
    final latest = sorted.first;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          if (latest.isSuspected) ...[
            const _UnderInvestigationBanner(),
            const SizedBox(height: 16),
          ],
          _LatestStatusCard(item: latest),
          const SizedBox(height: 24),
          Text('Screening History', style: AppText.sectionTitle()),
          const SizedBox(height: 12),
          for (int i = 0; i < sorted.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TbScreeningTile(item: sorted[i]),
            ),
        ],
      ),
    );
  }
}

class _UnderInvestigationBanner extends StatelessWidget {
  const _UnderInvestigationBanner();

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
              'Your latest screening flagged a suspected TB case — you are currently under investigation. '
              'Please follow up with your ASHA or facility.',
              style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestStatusCard extends StatelessWidget {
  final TbScreeningItem item;

  const _LatestStatusCard({required this.item});

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
          const AppIcon(name: 'lungs', fallback: Icons.coronavirus_outlined, size: 36, color: Colors.white),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
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
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusPill(
                      label: item.isSuspected ? 'Suspected TB' : 'Not Suspected',
                      solid: item.isSuspected,
                    ),
                    if (item.referralFlag) _StatusPill(label: 'Referred', solid: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool solid;

  const _StatusPill({required this.label, required this.solid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: solid ? Colors.white : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: solid ? const Color(0xFFDC2626) : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TbScreeningTile extends StatelessWidget {
  final TbScreeningItem item;

  const _TbScreeningTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (item.isSuspected ? const Color(0xFFDC2626) : const Color(0xFF10B981)).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isSuspected ? Icons.warning_amber_rounded : Icons.check_circle,
              color: item.isSuspected ? const Color(0xFFDC2626) : const Color(0xFF10B981),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(item.screeningDate) ?? '-', style: AppText.sectionTitle()),
                const SizedBox(height: 4),
                Text(
                  item.isSuspected ? 'Suspected — under investigation' : 'Not suspected',
                  style: AppText.label,
                ),
              ],
            ),
          ),
          if (item.referralFlag)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFDC2626).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Referred',
                style: TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyTbState extends StatelessWidget {
  const _EmptyTbState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon(name: 'lungs', fallback: Icons.coronavirus_outlined, size: 56, color: AppColors.muted),
            const SizedBox(height: 16),
            Text('No TB screenings on file', style: AppText.sectionTitle(), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Once your ASHA or facility records a TB screening, it will show up here.',
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
