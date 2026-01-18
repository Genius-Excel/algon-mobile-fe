// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CertificateItemFromJson(Map<String, dynamic> json) => CertificateItem(
      id: json['id'] as String,
      certificateNumber: json['certificate_number'] as String,
      certificateType: json['certificate_type'] as String,
      issueDate: json['issue_date'] as String,
      expiryDate: json['expiry_date'] as String?,
      verificationCode: json['verification_code'] as String,
      filePath: json['file_path'] as String?,
      isRevoked: json['is_revoked'] as bool,
      revokedAt: json['revoked_at'] as String?,
      createdAt: json['created_at'] as String,
      application: json['application'] as String,
      digitizationRequest: json['digitization_request'] as String?,
      isDownloadable: json['is_downloadable'] as bool?,
      applicationType: json['application_type'] as String,
      approvedAt: json['approved_at'] as String?,
      approvedBy: json['approved_by'] as String?,
    );

Map<String, dynamic> _$CertificateItemToJson(CertificateItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certificate_number': instance.certificateNumber,
      'certificate_type': instance.certificateType,
      'issue_date': instance.issueDate,
      'expiry_date': instance.expiryDate,
      'verification_code': instance.verificationCode,
      'file_path': instance.filePath,
      'is_revoked': instance.isRevoked,
      'revoked_at': instance.revokedAt,
      'created_at': instance.createdAt,
      'application': instance.application,
      'digitization_request': instance.digitizationRequest,
      'is_downloadable': instance.isDownloadable,
      'application_type': instance.applicationType,
      'approved_at': instance.approvedAt,
      'approved_by': instance.approvedBy,
    };

_$CertificateListResponseFromJson(Map<String, dynamic> json) =>
    CertificateListResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => CertificateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CertificateListResponseToJson(
        CertificateListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
