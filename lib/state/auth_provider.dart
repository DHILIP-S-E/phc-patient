import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/models/patient_auth_models.dart';
import '../data/repositories/patient_auth_repository.dart';
import '../data/repositories/patient_portal_repository.dart';
import '../data/token_storage.dart';
import 'profile_provider.dart';

// ---------------------------------------------------------------------------
// Singleton wiring. Screens/other providers pull these via ref.watch/ref.read
// rather than constructing ApiClient/TokenStorage/repositories themselves.
// ---------------------------------------------------------------------------

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokenStorage: ref.watch(tokenStorageProvider));
});

final patientAuthRepositoryProvider = Provider<PatientAuthRepository>((ref) {
  return PatientAuthRepository(ref.watch(apiClientProvider));
});

final patientPortalRepositoryProvider = Provider<PatientPortalRepository>((ref) {
  return PatientPortalRepository(ref.watch(apiClientProvider));
});

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

/// Sealed union of every stage of the OTP login flow. See
/// `phc_api/schemas/patient_auth.py::VerifyOtpResponse` for the backend
/// states this mirrors (`logged_in` / `select_patient` / `register`).
sealed class AuthState {
  const AuthState();
}

/// No token on device, or the stored token turned out to be invalid/expired.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// App start: checking secure storage / validating a stored token before
/// deciding between [AuthUnauthenticated] and [AuthAuthenticated].
class AuthCheckingSession extends AuthState {
  const AuthCheckingSession();
}

/// OTP requested for [mobile]; awaiting the code from the user. [email] is
/// set when the OTP was also dispatched to that address in parallel.
class AuthOtpSent extends AuthState {
  final String mobile;
  final String? email;
  const AuthOtpSent(this.mobile, {this.email});
}

/// Phone verified and it matches more than one patient record — the user
/// must pick which one they are before a session token is issued.
class AuthVerifiedNeedsSelection extends AuthState {
  final List<PatientCandidate> candidates;
  final String verifiedPhoneToken;
  const AuthVerifiedNeedsSelection(this.candidates, this.verifiedPhoneToken);
}

/// Phone verified but no patient record matches it — the user must
/// register before a session token is issued.
class AuthVerifiedNeedsRegistration extends AuthState {
  final String verifiedPhoneToken;
  const AuthVerifiedNeedsRegistration(this.verifiedPhoneToken);
}

/// Logged in with a saved token.
class AuthAuthenticated extends AuthState {
  final int patientId;
  const AuthAuthenticated(this.patientId);
}

/// Drives the OTP login flow end to end and owns the current [AuthState].
/// Import `authProvider` (below) from screens; call methods via
/// `ref.read(authProvider.notifier).<method>()`.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // build() must be synchronous for a plain Notifier; kick off the async
    // "is there already a valid token?" check and let it update state once
    // it resolves. Screens should treat AuthCheckingSession like a splash.
    Future.microtask(_restoreSession);
    return const AuthCheckingSession();
  }

  Future<void> _restoreSession() async {
    final token = await ref.read(tokenStorageProvider).readToken();
    if (token == null) {
      state = const AuthUnauthenticated();
      return;
    }
    try {
      // Validate the stored token (and learn the patientId it belongs to,
      // which isn't otherwise persisted) by fetching the profile with it.
      final profile = await ref.read(patientPortalRepositoryProvider).getProfile();
      state = AuthAuthenticated(profile.patientId);
    } catch (_) {
      await ref.read(tokenStorageProvider).clearToken();
      state = const AuthUnauthenticated();
    }
  }

  /// POST /patients/auth/request-otp, then move to [AuthOtpSent]. [email] is
  /// optional dual-channel delivery — if set, the OTP is also emailed.
  Future<void> requestOtp(String mobile, {String? email}) async {
    await ref.read(patientAuthRepositoryProvider).requestOtp(mobile, email: email);
    state = AuthOtpSent(mobile, email: email);
  }

  /// POST /patients/auth/verify-otp, then branch into whichever next state
  /// the backend reports (`logged_in` / `select_patient` / `register`).
  Future<void> verifyOtp(String mobile, String otp) async {
    final result = await ref.read(patientAuthRepositoryProvider).verifyOtp(otp, mobile: mobile);
    switch (result.status) {
      case 'logged_in':
        await _completeLogin(result.accessToken!);
      case 'select_patient':
        state = AuthVerifiedNeedsSelection(result.candidates, result.verifiedPhoneToken!);
      case 'register':
        state = AuthVerifiedNeedsRegistration(result.verifiedPhoneToken!);
      default:
        state = const AuthUnauthenticated();
    }
  }

  /// POST /patients/auth/register. Only valid from [AuthVerifiedNeedsRegistration].
  Future<void> register({required String name, String? dob, String? gender, String? email}) async {
    final current = state;
    if (current is! AuthVerifiedNeedsRegistration) return;
    final result = await ref
        .read(patientAuthRepositoryProvider)
        .register(current.verifiedPhoneToken, name, dob, gender, email: email);
    await _completeLogin(result.accessToken, patientId: result.patientId);
  }

  /// POST /patients/auth/select-patient. Only valid from [AuthVerifiedNeedsSelection].
  Future<void> selectPatient(int patientId) async {
    final current = state;
    if (current is! AuthVerifiedNeedsSelection) return;
    final result = await ref
        .read(patientAuthRepositoryProvider)
        .selectPatient(current.verifiedPhoneToken, patientId);
    await _completeLogin(result.accessToken, patientId: result.patientId);
  }

  Future<void> _completeLogin(String accessToken, {int? patientId}) async {
    await ref.read(tokenStorageProvider).saveToken(accessToken);
    if (patientId != null) {
      state = AuthAuthenticated(patientId);
    } else {
      // The `logged_in` verify-otp branch returns only an access_token (no
      // patient_id) — fetch the profile once the token is saved to learn it.
      final profile = await ref.read(patientPortalRepositoryProvider).getProfile();
      state = AuthAuthenticated(profile.patientId);
    }
    ref.invalidate(profileProvider);
  }

  /// Clears the saved token and returns to [AuthUnauthenticated].
  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clearToken();
    state = const AuthUnauthenticated();
    ref.invalidate(profileProvider);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
