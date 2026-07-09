// ============================================================
// PHC AI Assistant - App Root
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class PhcAiApp extends StatelessWidget {
  const PhcAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHC AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
      // Disable back gesture swipe to prevent accidental exit during voice
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
