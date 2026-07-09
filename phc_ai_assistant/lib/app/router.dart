// ============================================================
// PHC AI Assistant - App Router
// Named routes with auth guard for model download check
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/model_download/presentation/pages/model_download_page.dart';
import '../features/model_download/presentation/bloc/model_download_bloc.dart';
import '../features/assistant/presentation/pages/assistant_page.dart';
import '../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'di/injection_container.dart';

class AppRouter {
  static const String onboarding = '/onboarding';
  static const String modelDownload = '/model-download';
  static const String assistant = '/assistant';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings_) {
    switch (settings_.name) {
      case '/':
        return _splash();
      case onboarding:
        return _route(const OnboardingPage());
      case modelDownload:
        return _route(
          BlocProvider(
            create: (_) => sl<ModelDownloadBloc>(),
            child: const ModelDownloadPage(),
          ),
        );
      case assistant:
        return _route(
          BlocProvider(
            create: (_) => sl<AssistantBloc>(),
            child: const AssistantPage(),
          ),
        );
      case '/settings':
        return _route(const SettingsPage());
      default:
        return _route(const OnboardingPage());
    }
  }

  static MaterialPageRoute _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  /// Splash/router page that decides where to navigate on startup
  static MaterialPageRoute _splash() {
    return MaterialPageRoute(
      builder: (_) => const _SplashRouter(),
    );
  }
}

/// Determines startup route based on app state
class _SplashRouter extends StatefulWidget {
  const _SplashRouter();
  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;
    final modelReady = prefs.getBool(AppConstants.keyModelDownloaded) ?? false;

    if (!mounted) return;

    if (!onboardingDone) {
      Navigator.of(context).pushReplacementNamed(AppRouter.onboarding);
    } else if (!modelReady) {
      Navigator.of(context).pushReplacementNamed(AppRouter.modelDownload);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRouter.assistant);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Center(
        child: FadeTransition(
          opacity: _anim,
          child: ScaleTransition(
            scale: _anim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF006D77), Color(0xFF52B788)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF006D77).withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Aarogya',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PHC AI Assistant',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF83C5BE),
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF83C5BE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
