// ============================================================
// Offline Assistant Screen — host-app entry point
//
// Bridges phc-patient (Riverpod, no named routes) into the ported
// phc_ai_assistant engine (GetIt + flutter_bloc, originally driven by named
// routes in its own standalone app/router.dart). This widget replaces that
// router for the one flow phc-patient needs: check whether the on-device
// model is downloaded, show the download page if not, otherwise show the
// assistant page — mirroring phc_ai_assistant's _SplashRouterState._navigate.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/di/injection_container.dart';
import '../core/constants/app_constants.dart';
import '../features/assistant/presentation/bloc/assistant_bloc.dart';
import '../features/assistant/presentation/pages/assistant_page.dart';
import '../features/model_download/presentation/bloc/model_download_bloc.dart';
import '../features/model_download/presentation/pages/model_download_page.dart';

class OfflineAssistantScreen extends StatefulWidget {
  const OfflineAssistantScreen({super.key});

  @override
  State<OfflineAssistantScreen> createState() => _OfflineAssistantScreenState();
}

class _OfflineAssistantScreenState extends State<OfflineAssistantScreen> {
  bool? _modelReady; // null = still checking

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await configureDependencies();
    final modelReady = sl<SharedPreferences>().getBool(AppConstants.keyModelDownloaded) ?? false;
    if (mounted) setState(() => _modelReady = modelReady);
  }

  @override
  Widget build(BuildContext context) {
    if (_modelReady == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_modelReady!) {
      return BlocProvider(
        create: (_) => sl<ModelDownloadBloc>(),
        child: ModelDownloadPage(
          onReady: () => setState(() => _modelReady = true),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<AssistantBloc>(),
      child: const AssistantPage(),
    );
  }
}
