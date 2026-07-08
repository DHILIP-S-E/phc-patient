import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api_exception.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'otp_verify_screen.dart';

/// First screen of the OTP login flow: collects a mobile number and requests
/// an OTP via [AuthNotifier.requestOtp], then pushes [OtpVerifyScreen].
///
/// A later integration step will replace the `Navigator.push` below with a
/// go_router route — this screen is otherwise self-contained.
class MobileEntryScreen extends ConsumerStatefulWidget {
  const MobileEntryScreen({super.key});

  @override
  ConsumerState<MobileEntryScreen> createState() => _MobileEntryScreenState();
}

class _MobileEntryScreenState extends ConsumerState<MobileEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    try {
      await ref.read(authProvider.notifier).requestOtp(mobile, email: email.isEmpty ? null : email);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(mobile: mobile, email: email.isEmpty ? null : email),
        ),
      );
    } on ApiException catch (e) {
      setState(() => _errorText = e.message);
    } catch (_) {
      setState(() => _errorText = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      gradient: AppColors.heroGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text('GramCare', style: AppText.display(size: 30)),
                  const SizedBox(height: 8),
                  const Text(
                    'Your health, in your hands.',
                    textAlign: TextAlign.center,
                    style: AppText.body,
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Mobile number', style: AppText.sectionTitle()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, color: AppColors.ink),
                    decoration: InputDecoration(
                      hintText: 'Enter your 10-digit mobile number',
                      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Mobile number is required';
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                        return 'Enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email (optional)', style: AppText.sectionTitle()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, color: AppColors.ink),
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return null;
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                  const SizedBox(height: 24),
                  DarkCtaButton(
                    label: _isSubmitting ? 'Sending...' : 'Send OTP',
                    onPressed: _isSubmitting ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
