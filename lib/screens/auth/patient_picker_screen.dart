import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api_exception.dart';
import '../../data/models/patient_auth_models.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// Shown after OTP verification when the phone number matches more than one
/// patient record (`VerifyOtpResult.status == 'select_patient'`). The user
/// taps the profile that's theirs, which completes login via
/// `AuthNotifier.selectPatient`. On success the auth state flips to
/// [AuthAuthenticated] and whatever widget is watching `authProvider` at the
/// app root takes over navigation — this screen doesn't navigate itself.
class PatientPickerScreen extends ConsumerStatefulWidget {
  final List<PatientCandidate> candidates;
  final String verifiedPhoneToken;

  const PatientPickerScreen({super.key, required this.candidates, required this.verifiedPhoneToken});

  @override
  ConsumerState<PatientPickerScreen> createState() => _PatientPickerScreenState();
}

class _PatientPickerScreenState extends ConsumerState<PatientPickerScreen> {
  int? _selectingId;
  String? _error;

  Future<void> _select(PatientCandidate candidate) async {
    setState(() {
      _selectingId = candidate.id;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).selectPatient(candidate.id);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _selectingId = null;
        _error = e is ApiException ? e.message : 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Who are you?', style: AppText.display()),
              const SizedBox(height: 10),
              const Text(
                'This phone number is linked to multiple profiles — who are you?',
                style: AppText.body,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)),
                  child: Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12)),
                ),
                const SizedBox(height: 16),
              ],
              for (final candidate in widget.candidates) ...[
                _CandidateCard(
                  candidate: candidate,
                  isLoading: _selectingId == candidate.id,
                  isDisabled: _selectingId != null && _selectingId != candidate.id,
                  onTap: () => _select(candidate),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _selectingId != null ? null : () => ref.read(authProvider.notifier).logout(),
                  child: const Text(
                    'Not you? Use a different number',
                    style: TextStyle(color: AppColors.inkSoft, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final PatientCandidate candidate;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _CandidateCard({
    required this.candidate,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: GestureDetector(
        onTap: isDisabled || isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                    ),
                    if (candidate.dob != null) ...[
                      const SizedBox(height: 4),
                      Text('DOB: ${_formatDob(candidate.dob!)}', style: AppText.label),
                    ],
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              else
                const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

const _monthAbbrev = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
];

/// Formats a backend ISO `yyyy-MM-dd` string as `5 Jan 1990`; falls back to
/// the raw string if it doesn't parse (defensive — the field is a plain
/// `String` on the client per project convention, not a validated `DateTime`).
String _formatDob(String iso) {
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return iso;
  return '${parsed.day} ${_monthAbbrev[parsed.month - 1]} ${parsed.year}';
}
