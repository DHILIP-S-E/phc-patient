import '../api_client.dart';
import '../models/child_models.dart';
import '../models/clinical_models.dart';
import '../models/facility_models.dart';
import '../models/ncd_tb_models.dart';
import '../models/patient_profile.dart';
import '../models/pregnancy_models.dart';
import '../models/scheme_models.dart';
import '../models/visit_models.dart';

/// Wraps the authenticated patient-portal read surface —
/// `phc_api/routers/patient_portal.py` (`/patients/me/*`). Every call goes
/// through [ApiClient.unwrap]; the bearer token is attached automatically by
/// [ApiClient]'s interceptor, so no token handling happens here.
class PatientPortalRepository {
  final ApiClient _client;

  PatientPortalRepository(this._client);

  /// GET /patients/me/profile.
  Future<PatientProfile> getProfile() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/profile'),
      (json) => PatientProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /patients/me/pregnancy — `data` is legitimately `null` for a
  /// patient with no pregnancy record.
  Future<PregnancyDetail?> getPregnancy() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/pregnancy'),
      (json) => json == null ? null : PregnancyDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /patients/me/child — `data` is legitimately `null` for a patient
  /// with no child record.
  Future<ChildDetail?> getChild() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/child'),
      (json) => json == null ? null : ChildDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /patients/me/ncd.
  Future<List<NcdScreeningItem>> getNcdHistory() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/ncd'),
      (json) => (json as List<dynamic>)
          .map((e) => NcdScreeningItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /patients/me/tb.
  Future<List<TbScreeningItem>> getTbHistory() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/tb'),
      (json) => (json as List<dynamic>)
          .map((e) => TbScreeningItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /patients/me/visits.
  Future<List<VisitItem>> getVisits() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/visits'),
      (json) =>
          (json as List<dynamic>).map((e) => VisitItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  /// GET /patients/me/queue-status.
  Future<QueueStatus> getQueueStatus() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/queue-status'),
      (json) => QueueStatus.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /patients/me/lab-tests.
  Future<List<LabTestItem>> getLabTests() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/lab-tests'),
      (json) => (json as List<dynamic>)
          .map((e) => LabTestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /patients/me/referrals.
  Future<List<ReferralItem>> getReferrals() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/referrals'),
      (json) => (json as List<dynamic>)
          .map((e) => ReferralItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /patients/me/notifications.
  Future<List<NotificationItem>> getNotifications() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/notifications'),
      (json) => (json as List<dynamic>)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /patients/me/schemes.
  Future<List<SchemeItem>> getSchemes() {
    return _client.unwrap(
      () => _client.dio.get('/patients/me/schemes'),
      (json) =>
          (json as List<dynamic>).map((e) => SchemeItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  /// GET /patients/me/facilities/nearby.
  Future<List<NearbyFacilityItem>> getNearbyFacilities(
    double lat,
    double lng, [
    double radiusKm = 25.0,
  ]) {
    return _client.unwrap(
      () => _client.dio.get(
        '/patients/me/facilities/nearby',
        queryParameters: {'lat': lat, 'lng': lng, 'radius_km': radiusKm},
      ),
      (json) => (json as List<dynamic>)
          .map((e) => NearbyFacilityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
