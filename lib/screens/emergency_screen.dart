import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/app_icon.dart';
import '../theme/app_theme.dart';
import 'nearby_phc_screen.dart';

/// High-contrast, no-backend "in an emergency" screen: one-tap call to the
/// national ambulance number, a way to share the patient's live location,
/// and a shortcut to the nearest facility list.
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  static const _emergencyNumber = '108';
  static const _emergencyRed = Color(0xFFDC2626);
  static const _emergencyRedDark = Color(0xFF991B1B);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _locating = false;
  String? _locationStatus;

  Future<void> _callEmergency() async {
    final uri = Uri(scheme: 'tel', path: EmergencyScreen._emergencyNumber);
    try {
      final launched = await launchUrl(uri);
      if (!launched && mounted) {
        _showMessage('Could not start the call. Please dial ${EmergencyScreen._emergencyNumber} manually.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Could not start the call. Please dial ${EmergencyScreen._emergencyNumber} manually.');
      }
    }
  }

  Future<void> _shareLocation() async {
    setState(() {
      _locating = true;
      _locationStatus = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Turn on location services to share your position.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required to share your position.');
      }

      final position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;
      final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = 'Your location: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
      });

      final launched = await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showMessage('Could not open Maps. Your coordinates are shown above.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EmergencyScreen._emergencyRedDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Emergency',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Stay calm. Help is one tap away.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildCallButton(),
                      const SizedBox(height: 28),
                      _buildActionCard(
                        iconName: 'location_pin',
                        fallback: Icons.share_location,
                        title: 'Share My Location',
                        subtitle: _locationStatus ?? 'Send your live location to responders via Maps.',
                        loading: _locating,
                        onTap: _locating ? null : _shareLocation,
                      ),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        iconName: 'stethoscope',
                        fallback: Icons.local_hospital,
                        title: 'Nearest PHC / CHC',
                        subtitle: 'Find the closest health facility to head to.',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NearbyPhcScreen()));
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton() {
    return Center(
      child: GestureDetector(
        onTap: _callEmergency,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: EmergencyScreen._emergencyRed,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10)),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 4),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.call, color: Colors.white, size: 44),
              SizedBox(height: 10),
              Text(
                'Call 108',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ambulance',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String iconName,
    required IconData fallback,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: AppIcon(name: iconName, fallback: fallback, color: EmergencyScreen._emergencyRed, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppText.body),
                ],
              ),
            ),
            if (loading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
