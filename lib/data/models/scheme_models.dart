import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheme_models.freezed.dart';
part 'scheme_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::SchemeItem`
/// (GET /patients/me/schemes).
@freezed
abstract class SchemeItem with _$SchemeItem {
  const factory SchemeItem({
    required String key,
    required String name,
    required String description,
    required List<String> benefits,
    @JsonKey(name: 'required_documents') required List<String> requiredDocuments,
    required String category,
  }) = _SchemeItem;

  factory SchemeItem.fromJson(Map<String, dynamic> json) => _$SchemeItemFromJson(json);
}
