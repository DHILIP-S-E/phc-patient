import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/visit_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';
import '../components/app_icon.dart';

/// GET /patients/me/queue-status. Screen-local — no other screen needs the
/// live queue token, so the provider lives next to its only consumer.
final _queueStatusProvider = FutureProvider<QueueStatus>((ref) {
  return ref.watch(patientPortalRepositoryProvider).getQueueStatus();
});

/// Shows the patient's live queue token for today's active visit (gradient
/// hero card), or a calm empty state when there's no active visit.
class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueStatus = ref.watch(_queueStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text(
          'Queue Status',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_queueStatusProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: queueStatus.when(
          data: (status) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: (status.hasActiveVisit && status.visit != null)
                ? _QueueTokenCard(visit: status.visit!)
                : const _EmptyQueueState(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load your queue status.\n$error',
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

class _QueueTokenCard extends StatelessWidget {
  final VisitItem visit;

  const _QueueTokenCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Token',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _titleCase(visit.status),
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  visit.queueToken?.toString() ?? '—',
                  style: AppText.display(size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Colors.white24),
              const SizedBox(height: 16),
              Row(
                children: [
                  const AppIcon(name: 'hospital', fallback: Icons.local_hospital_outlined, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Facility #${visit.facilityId}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const AppIcon(name: 'clock', fallback: Icons.access_time, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    visit.calledAt != null ? 'Called ${_formatDateTime(visit.calledAt!)}' : 'Waiting to be called',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              _InfoRow(label: 'OP Number', value: visit.opNumber),
              const Divider(height: 20, color: AppColors.hairline),
              _InfoRow(label: 'Visit Type', value: _titleCase(visit.visitType)),
              const Divider(height: 20, color: AppColors.hairline),
              _InfoRow(label: 'Priority', value: _titleCase(visit.priority)),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppText.label),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
      ],
    );
  }
}

class _EmptyQueueState extends StatelessWidget {
  const _EmptyQueueState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const AppIcon(name: 'ticket', fallback: Icons.confirmation_number_outlined, color: AppColors.primary, size: 60),
          ),
          const SizedBox(height: 24),
          const Text(
            'No active visit today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'When you check in at a facility, your live queue token will appear here.',
            textAlign: TextAlign.center,
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}

/// "IN_CONSULTATION" -> "In Consultation". Backend enums serialize as their
/// raw member name (see visit_models.dart's doc comment).
String _titleCase(String raw) {
  return raw
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');
}

/// Formats an ISO datetime string as e.g. "8 Jul, 10:15 AM" without pulling
/// in intl (not a project dependency) — DateTime.tryParse handles ISO 8601.
String _formatDateTime(String iso) {
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${months[dt.month - 1]}, $hour12:$minute $period';
}
