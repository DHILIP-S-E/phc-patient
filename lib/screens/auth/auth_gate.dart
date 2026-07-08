import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../dashboard/adaptive_dashboard_shell.dart';
import 'mobile_entry_screen.dart';
import 'patient_picker_screen.dart';
import 'register_screen.dart';

/// Root of the app. Watches [authProvider] and swaps the entire screen based
/// on where the citizen is in the OTP login flow — this is a reactive
/// top-level switch rather than named routes, since every step already
/// drives off [AuthState] and re-routing through go_router would just
/// duplicate that state machine.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return switch (auth) {
      AuthCheckingSession() => const _SplashScreen(),
      AuthUnauthenticated() || AuthOtpSent() => const MobileEntryScreen(),
      AuthVerifiedNeedsSelection(:final candidates, :final verifiedPhoneToken) => PatientPickerScreen(
          candidates: candidates,
          verifiedPhoneToken: verifiedPhoneToken,
        ),
      AuthVerifiedNeedsRegistration(:final verifiedPhoneToken) => RegisterScreen(
          verifiedPhoneToken: verifiedPhoneToken,
        ),
      AuthAuthenticated() => const AdaptiveDashboardShell(),
    };
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
