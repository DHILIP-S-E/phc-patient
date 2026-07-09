// ============================================================
// PHC AI Assistant - Settings Page
// ============================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/model_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_formatter.dart';
import '../../../../features/model_download/domain/repositories/model_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _avatarGender = 'female';
  double _ttsSpeed = 0.85;
  double _ttsPitch = 1.0;
  String _modelVersion = 'Not downloaded';
  bool _modelDownloaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarGender = prefs.getString(AppConstants.keyAvatarGender) ?? 'female';
      _ttsSpeed = prefs.getDouble(AppConstants.keyTtsSpeed) ?? 0.85;
      _ttsPitch = prefs.getDouble(AppConstants.keyTtsPitch) ?? 1.0;
      _modelVersion = prefs.getString(AppConstants.keyModelVersion) ?? 'Not downloaded';
      _modelDownloaded = prefs.getBool(AppConstants.keyModelDownloaded) ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is bool) await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Avatar Section ─────────────────────────────
            _buildSectionHeader(context, 'Avatar', Icons.face_rounded),
            _buildCard([
              ListTile(
                title: const Text('Avatar Gender'),
                subtitle: const Text('Choose assistant appearance'),
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'female', label: Text('Female')),
                    ButtonSegment(value: 'male', label: Text('Male')),
                  ],
                  selected: {_avatarGender},
                  onSelectionChanged: (s) {
                    setState(() => _avatarGender = s.first);
                    _saveSetting(AppConstants.keyAvatarGender, s.first);
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 16),

            // ── Voice Section ──────────────────────────────
            _buildSectionHeader(context, 'Voice', Icons.record_voice_over_rounded),
            _buildCard([
              _buildSliderTile(
                context,
                title: 'Speech Rate',
                value: _ttsSpeed,
                min: 0.5,
                max: 1.5,
                divisions: 10,
                label: _ttsSpeed.toStringAsFixed(2),
                onChanged: (v) {
                  setState(() => _ttsSpeed = v);
                  _saveSetting(AppConstants.keyTtsSpeed, v);
                },
              ),
              const Divider(height: 1),
              _buildSliderTile(
                context,
                title: 'Voice Pitch',
                value: _ttsPitch,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                label: _ttsPitch.toStringAsFixed(2),
                onChanged: (v) {
                  setState(() => _ttsPitch = v);
                  _saveSetting(AppConstants.keyTtsPitch, v);
                },
              ),
            ]),

            const SizedBox(height: 16),

            // ── AI Model Section ───────────────────────────
            _buildSectionHeader(context, 'AI Model', Icons.smart_toy_rounded),
            _buildCard([
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (_modelDownloaded ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _modelDownloaded
                        ? Icons.check_circle_rounded
                        : Icons.download_rounded,
                    color: _modelDownloaded ? AppColors.success : AppColors.warning,
                    size: 20,
                  ),
                ),
                title: const Text('Model Status'),
                subtitle: Text(
                  _modelDownloaded ? 'Downloaded & Verified' : 'Not Downloaded',
                ),
                trailing: Chip(
                  label: Text(
                    _modelDownloaded ? 'Ready' : 'Missing',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _modelDownloaded
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.warning.withValues(alpha: 0.2),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tag_rounded,
                      color: AppColors.primaryLight, size: 20),
                ),
                title: const Text('Model Version'),
                subtitle: Text(_modelVersion),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storage_rounded,
                      color: AppColors.primaryLight, size: 20),
                ),
                title: const Text('Model Size'),
                subtitle: Text(SizeFormatter.format(ModelConstants.modelSizeBytes)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.errorLight, size: 20),
                ),
                title: const Text(
                  'Delete AI Model',
                  style: TextStyle(color: AppColors.errorLight),
                ),
                subtitle: const Text('Will require re-download'),
                onTap: _confirmDeleteModel,
              ),
            ]),

            const SizedBox(height: 16),

            // ── About Section ──────────────────────────────
            _buildSectionHeader(context, 'About', Icons.info_rounded),
            _buildCard([
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_hospital_rounded,
                      color: AppColors.primaryLight, size: 20),
                ),
                title: const Text('PHC AI Assistant'),
                subtitle: const Text('Version ${AppConstants.appVersion}'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.health_and_safety_rounded,
                      color: AppColors.primaryLight, size: 20),
                ),
                title: const Text('Health Disclaimer'),
                subtitle: const Text(
                    'This app provides health education only and is not a medical device.'),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext ctx, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                  color: AppColors.primaryLight,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSliderTile(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                      )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryLight,
                        )),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.downloadTrack,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteModel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete AI Model?'),
        content: const Text(
            'This will delete the downloaded AI model. You will need to download it again to use the assistant.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Actually delete the model from disk and SharedPreferences
      await sl<ModelRepository>().deleteModel();
      if (mounted) {
        // Pop back out to the host app's Offline entry point entirely (past
        // Settings AND the now-modelless Assistant page). Re-entering Offline
        // mode re-checks the model flag and correctly shows the download flow.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
