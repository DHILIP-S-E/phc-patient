import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../components/app_icon.dart';
import '../data/api_exception.dart';
import '../data/models/facility_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';

/// Shows the patient's nearest health facilities, sorted by distance.
/// Fetches the device's current position (via `geolocator`) then calls
/// `GET /patients/me/facilities/nearby` through [PatientPortalRepository].
class NearbyPhcScreen extends ConsumerStatefulWidget {
  const NearbyPhcScreen({super.key});

  @override
  ConsumerState<NearbyPhcScreen> createState() => _NearbyPhcScreenState();
}

class _NearbyPhcScreenState extends ConsumerState<NearbyPhcScreen> {
  bool _loading = true;
  String? _errorMessage;
  List<NearbyFacilityItem> _facilities = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final position = await _determinePosition();
      final facilities = await ref
          .read(patientPortalRepositoryProvider)
          .getNearbyFacilities(position.latitude, position.longitude, 25.0);
      facilities.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      if (!mounted) return;
      setState(() {
        _facilities = facilities;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is ApiException ? e.message : e.toString();
        _loading = false;
      });
    }
  }

  /// Resolves the device's current position, handling the permission
  /// lifecycle explicitly so [_errorMessage] can show a clear reason
  /// (services off / denied / denied forever) rather than a raw exception.
  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are turned off. Please enable location and try again.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied. Allow location access to find nearby facilities.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Enable it from your device settings to continue.',
      );
    }

    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HeaderIconButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).maybePop()),
                  const SizedBox(width: 12),
                  Text('Nearby Facilities', style: AppText.sectionTitle()),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(name: 'location_pin', fallback: Icons.location_off, size: 48, color: AppColors.muted),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(_errorMessage!, textAlign: TextAlign.center, style: AppText.body),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: DarkCtaButton(label: 'Try Again', icon: Icons.refresh, onPressed: _load),
            ),
          ],
        ),
      );
    }
    if (_facilities.isEmpty) {
      return Center(
        child: Text('No facilities found within 25 km.', style: AppText.body),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _facilities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _FacilityCard(facility: _facilities[index]),
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final NearbyFacilityItem facility;

  const _FacilityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: const AppIcon(name: 'stethoscope', fallback: Icons.local_hospital, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(_formatType(facility.type), style: AppText.label),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(10)),
            child: Text(
              '${facility.distanceKm.toStringAsFixed(1)} km',
              style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatType(String type) {
    switch (type) {
      case 'SUB_CENTRE':
        return 'Sub Centre';
      case 'PHC':
        return 'Primary Health Centre';
      case 'CHC':
        return 'Community Health Centre';
      case 'SUB_DISTRICT_HOSPITAL':
        return 'Sub District Hospital';
      case 'DISTRICT_HOSPITAL':
        return 'District Hospital';
      default:
        return type;
    }
  }
}
