// ============================================================
// PHC AI Assistant - Onboarding Page
// Beautiful multi-step onboarding with animations
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'en';
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      icon: Icons.local_hospital_rounded,
      iconColor: AppColors.primary,
      title: 'Welcome to\nAarogya',
      description:
          'Your personal AI healthcare assistant, designed for Indian Primary Healthcare Centres. Powered by Gemma 3 AI — fully offline.',
      gradient: LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.15), Colors.transparent],
      ),
    ),
    _OnboardingStep(
      icon: Icons.language_rounded,
      iconColor: AppColors.accent,
      title: 'Your Language,\nYour Choice',
      description:
          'Aarogya speaks 12 Indian languages including Hindi, Tamil, Telugu, Bengali, and more. Select your preferred language below.',
      gradient: LinearGradient(
        colors: [AppColors.accent.withValues(alpha: 0.15), Colors.transparent],
      ),
      hasLanguageSelector: true,
    ),
    _OnboardingStep(
      icon: Icons.mic_rounded,
      iconColor: AppColors.secondary,
      title: 'Just Speak\nNaturally',
      description:
          'No typing needed. Simply speak your symptoms or health questions. Aarogya listens, understands, and responds — even without internet.',
      gradient: LinearGradient(
        colors: [AppColors.secondary.withValues(alpha: 0.15), Colors.transparent],
      ),
    ),
    _OnboardingStep(
      icon: Icons.health_and_safety_rounded,
      iconColor: AppColors.warning,
      title: 'Important\nDisclaimer',
      description:
          'Aarogya provides health education and guidance only. It is NOT a replacement for medical consultation. Always visit a qualified doctor for diagnosis and treatment.',
      gradient: LinearGradient(
        colors: [AppColors.warning.withValues(alpha: 0.15), Colors.transparent],
      ),
      isDisclaimer: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);
    await prefs.setString(AppConstants.keySelectedLanguage, _selectedLanguage);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/model-download');
    }
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  ),
                ),
              ),
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _steps.length,
                  itemBuilder: (context, i) =>
                      _buildStep(context, _steps[i], i),
                ),
              ),
              // Bottom navigation
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, _OnboardingStep step, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Floating animated icon
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            ),
            child: _buildIconBlob(step),
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
          // Language selector (step 2)
          if (step.hasLanguageSelector) ...[
            const SizedBox(height: 28),
            _buildLanguageGrid(context),
          ],
          // Disclaimer badge
          if (step.isDisclaimer) ...[
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By continuing, you agree to use this app as a health education tool only.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.warningLight,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      )),
    );
  }

  Widget _buildIconBlob(_OnboardingStep step) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            step.iconColor.withValues(alpha: 0.25),
            step.iconColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: step.iconColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Icon(
        step.icon,
        size: 64,
        color: step.iconColor,
      ),
    );
  }

  Widget _buildLanguageGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: LanguageConstants.supportedLanguages.map((lang) {
        final isSelected = _selectedLanguage == lang.code;
        return GestureDetector(
          onTap: () => setState(() => _selectedLanguage = lang.code),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : AppColors.glassWhite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.glassBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang.flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  lang.nativeName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final isLast = _currentPage == _steps.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        children: [
          // Page dots
          Row(
            children: List.generate(
              _steps.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                width: i == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Next / Get Started button
          FilledButton(
            onPressed: _nextPage,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLast ? 'Get Started' : 'Next'),
                const SizedBox(width: 8),
                Icon(
                  isLast
                      ? Icons.rocket_launch_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStep {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Gradient gradient;
  final bool hasLanguageSelector;
  final bool isDisclaimer;

  const _OnboardingStep({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.gradient,
    this.hasLanguageSelector = false,
    this.isDisclaimer = false,
  });
}
