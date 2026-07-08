import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api_exception.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

const _monthAbbrev = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
];

/// Shown after OTP verification when no patient record matches the phone
/// number (`VerifyOtpResult.status == 'register'`). Collects the minimum
/// fields the backend needs (`schemas/patient_auth.py::RegisterPatientRequest`)
/// and completes login via `AuthNotifier.register`. On success the auth state
/// flips to [AuthAuthenticated] and whatever widget is watching `authProvider`
/// at the app root takes over navigation — this screen doesn't navigate itself.
class RegisterScreen extends ConsumerStatefulWidget {
  final String verifiedPhoneToken;

  const RegisterScreen({super.key, required this.verifiedPhoneToken});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  bool _isSubmitting = false;
  String? _error;

  static const _genderOptions = [
    ('male', 'Male'),
    ('female', 'Female'),
    ('other', 'Other'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).register(
        name: _nameController.text.trim(),
        dob: _dob == null ? null : _isoDate(_dob!),
        gender: _gender,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = e is ApiException ? e.message : 'Something went wrong. Please try again.';
      });
    }
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.muted),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.hairline)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.hairline)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Create your\nhealth profile', style: AppText.display()),
                const SizedBox(height: 10),
                const Text(
                  "We couldn't find an existing profile for this number — tell us a bit about yourself.",
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
                Text('Full name', style: AppText.sectionTitle()),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(hint: 'Enter your full name', icon: Icons.person_outline),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 18),
                Text('Date of birth', style: AppText.sectionTitle()),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDob,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: AppColors.muted, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          _dob == null ? 'Select date of birth (optional)' : _formatDisplayDate(_dob!),
                          style: TextStyle(
                            fontSize: 14,
                            color: _dob == null ? AppColors.muted : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Gender', style: AppText.sectionTitle()),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: _inputDecoration(hint: 'Select gender (optional)', icon: Icons.wc_outlined),
                  items: [
                    for (final option in _genderOptions)
                      DropdownMenuItem(value: option.$1, child: Text(option.$2)),
                  ],
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 28),
                DarkCtaButton(
                  label: _isSubmitting ? 'Creating…' : 'Create my health profile',
                  onPressed: _isSubmitting ? null : _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _formatDisplayDate(DateTime d) => '${d.day} ${_monthAbbrev[d.month - 1]} ${d.year}';
