import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/patient_profile.dart';
import 'auth_provider.dart';

/// The current patient's profile (GET /patients/me/profile), including the
/// `category` field screens use to pick which dashboard to show
/// ("pregnant" | "child" | "ncd" | "tb" | "senior" | "adult").
///
/// Watches [authProvider] so it automatically refetches whenever auth state
/// flips to [AuthAuthenticated] (fresh login, or session restored on app
/// start); returns `null` whenever there's no authenticated patient to fetch
/// a profile for. Call `ref.invalidate(profileProvider)` to force a refetch
/// (e.g. after the patient's record changes server-side).
final profileProvider = FutureProvider<PatientProfile?>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth is! AuthAuthenticated) return null;
  return ref.read(patientPortalRepositoryProvider).getProfile();
});
