import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app_icon.dart';
import '../data/models/scheme_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';

/// GET /patients/me/schemes — screen-local, mirrors notifications_screen.dart's
/// pattern of a small screen-owned FutureProvider next to its only consumer.
final _schemesProvider = FutureProvider<List<SchemeItem>>((ref) {
  return ref.watch(patientPortalRepositoryProvider).getSchemes();
});

/// Government health schemes the logged-in patient is currently eligible
/// for — computed server-side from the same category (pregnant/child/ncd/
/// tb/senior/adult) that drives which dashboard they see (see
/// phc_api/services/patient/scheme_eligibility_service.py).
class HealthSchemesScreen extends ConsumerWidget {
  const HealthSchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemes = ref.watch(_schemesProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text(
          'Health Schemes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_schemesProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: schemes.when(
          data: (items) {
            if (items.isEmpty) return const _EmptySchemesState();
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _SchemeCard(scheme: items[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load health schemes.\n$error',
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

class _SchemeCard extends StatelessWidget {
  final SchemeItem scheme;

  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                child: const AppIcon(
                  name: 'shield',
                  fallback: Icons.verified_outlined,
                  color: Color(0xFF16A34A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  scheme.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(scheme.description, style: AppText.body),
          const SizedBox(height: 12),
          Text('Benefits', style: AppText.label.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...scheme.benefits.map((b) => _BulletLine(text: b)),
          const SizedBox(height: 10),
          Text('Documents needed', style: AppText.label.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...scheme.requiredDocuments.map((d) => _BulletLine(text: d)),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;

  const _BulletLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: CircleAvatar(radius: 2.5, backgroundColor: AppColors.muted),
          ),
          Expanded(child: Text(text, style: AppText.body)),
        ],
      ),
    );
  }
}

class _EmptySchemesState extends StatelessWidget {
  const _EmptySchemesState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const AppIcon(
              name: 'shield',
              fallback: Icons.verified_outlined,
              color: Color(0xFF16A34A),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No schemes to show yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'Eligible government health schemes will appear here based on your health profile.',
            textAlign: TextAlign.center,
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}
