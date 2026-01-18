import 'package:json_annotation/json_annotation.dart';

part 'certificate_models.g.dart';

@JsonSerializable()
class CertificateItem {
  final String id;
  @JsonKey(name: 'certificate_number')
  final String certificateNumber;
  @JsonKey(name: 'certificate_type')
  final String certificateType;
  @JsonKey(name: 'issue_date')
  final String issueDate;
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  @JsonKey(name: 'verification_code')
  final String verificationCode;
  @JsonKey(name: 'file_path')
  final String? filePath;
  @JsonKey(name: 'is_revoked')
  final bool isRevoked;
  @JsonKey(name: 'revoked_at')
  final String? revokedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String application;
  @JsonKey(name: 'digitization_request')
  final String? digitizationRequest;
  @JsonKey(name: 'is_downloadable')
  final bool? isDownloadable;
  @JsonKey(name: 'application_type')
  final String applicationType;
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  const CertificateItem({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.issueDate,
    this.expiryDate,
    required this.verificationCode,
    this.filePath,
    required this.isRevoked,
    this.revokedAt,
    required this.createdAt,
    required this.application,
    this.digitizationRequest,
    this.isDownloadable,
    required this.applicationType,
    this.approvedAt,
    this.approvedBy,
  });

  factory CertificateItem.fromJson(Map<String, dynamic> json) =>
      _$CertificateItemFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateItemToJson(this);
}

@JsonSerializable()
class CertificateListResponse {
  final String message;
  final List<CertificateItem> data;

  const CertificateListResponse({
    required this.message,
    required this.data,
  });

  factory CertificateListResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateListResponseToJson(this);
}
