import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api_exception.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

/// Second screen of the OTP login flow: collects the 6-digit code sent to
/// [mobile] and calls [AuthNotifier.verifyOtp], then branches on whichever
/// next [AuthState] the backend reports.
///
/// Routing beyond this screen (into the authenticated app shell, a patient
/// picker, or registration) is left as TODOs — a later integration step
/// wires real go_router routes once those screens exist.
class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String mobile;
  final VoidCallback? onSuccess;

  const OtpVerifyScreen({super.key, required this.mobile, this.onSuccess});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isSubmitting = false;
  bool _isResending = false;
  String? _errorText;
  bool _verifiedSuccessfully = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await ref.read(authProvider.notifier).verifyOtp(widget.mobile, _otpController.text.trim());
      if (!mounted) return;

      final state = ref.read(authProvider);
      switch (state) {
        case AuthAuthenticated():
          // TODO(routing): once go_router is wired, replace this screen with
          // the authenticated app shell instead of showing an inline banner.
          setState(() => _verifiedSuccessfully = true);
          widget.onSuccess?.call();
        case AuthVerifiedNeedsSelection():
          // TODO(routing): push a patient-picker screen here, passing
          // state.candidates and state.verifiedPhoneToken, then call
          // authProvider.notifier.selectPatient(patientId) once chosen.
          break;
        case AuthVerifiedNeedsRegistration():
          // TODO(routing): push a registration screen here, passing
          // state.verifiedPhoneToken, then call
          // authProvider.notifier.register(...) once submitted.
          break;
        default:
          setState(() => _errorText = 'Verification failed. Please try again.');
      }
    } on ApiException catch (e) {
      setState(() => _errorText = e.message);
    } catch (_) {
      setState(() => _errorText = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _isResending = true;
      _errorText = null;
    });
    try {
      await ref.read(authProvider.notifier).requestOtp(widget.mobile);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent')),
      );
    } on ApiException catch (e) {
      setState(() => _errorText = e.message);
    } catch (_) {
      setState(() => _errorText = 'Could not resend OTP. Please try again.');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _verifiedSuccessfully ? _buildSuccess() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(color: Color(0xFFECFDF5), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 44),
        ),
        const SizedBox(height: 24),
        Text('You\'re verified!', style: AppText.display(size: 24)),
        const SizedBox(height: 8),
        const Text(
          'Signed in successfully.',
          textAlign: TextAlign.center,
          style: AppText.body,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Verify OTP', style: AppText.display(size: 26)),
          const SizedBox(height: 8),
          Text(
            'Enter the code sent to ${widget.mobile}',
            textAlign: TextAlign.center,
            style: AppText.body,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            autofocus: true,
            maxLength: 6,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 22, letterSpacing: 12, color: AppColors.ink, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••••',
              hintStyle: const TextStyle(color: AppColors.muted, fontSize: 22, letterSpacing: 12),
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
              if (v.isEmpty) return 'Enter the OTP';
              if (!RegExp(r'^[0-9]{6}$').hasMatch(v)) return 'Enter the 6-digit code';
              return null;
            },
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 12),
            Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 24),
          DarkCtaButton(
            label: _isSubmitting ? 'Verifying...' : 'Verify',
            onPressed: _isSubmitting ? null : _submit,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isResending ? null : _resend,
            child: Text(
              _isResending ? 'Resending...' : 'Resend OTP',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
