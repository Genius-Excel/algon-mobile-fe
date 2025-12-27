// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digitization_application_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitizationApplicationRequest _$DigitizationApplicationRequestFromJson(
        Map<String, dynamic> json) =>
    DigitizationApplicationRequest(
      nin: json['nin'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      state: json['state'] as String,
      localGovernment: json['local_government'] as String,
      phoneNumber: json['phone_number'] as String,
      certificateReferenceNumber:
          json['certificate_reference_number'] as String?,
    );

Map<String, dynamic> _$DigitizationApplicationRequestToJson(
        DigitizationApplicationRequest instance) =>
    <String, dynamic>{
      'nin': instance.nin,
      'email': instance.email,
      'full_name': instance.fullName,
      'state': instance.state,
      'local_government': instance.localGovernment,
      'phone_number': instance.phoneNumber,
      'certificate_reference_number': instance.certificateReferenceNumber,
    };

DigitizationUserData _$DigitizationUserDataFromJson(
        Map<String, dynamic> json) =>
    DigitizationUserData(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      state: json['state'] as String,
      localGovernment: json['local_government'] as String,
      certificateReferenceNumber:
          json['certificate_reference_number'] as String?,
      nin: json['nin'] as String,
      fullName: json['full_name'] as String,
      paymentStatus: json['payment_status'] as String,
      verificationStatus: json['verification_status'] as String,
      reviewedAt: json['reviewed_at'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      reviewedBy: json['reviewed_by'] as String?,
    );

Map<String, dynamic> _$DigitizationUserDataToJson(
        DigitizationUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'state': instance.state,
      'local_government': instance.localGovernment,
      'certificate_reference_number': instance.certificateReferenceNumber,
      'nin': instance.nin,
      'full_name': instance.fullName,
      'payment_status': instance.paymentStatus,
      'verification_status': instance.verificationStatus,
      'reviewed_at': instance.reviewedAt,
      'remarks': instance.remarks,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'reviewed_by': instance.reviewedBy,
    };

DigitizationFeeData _$DigitizationFeeDataFromJson(Map<String, dynamic> json) =>
    DigitizationFeeData(
      applicationFee: DigitizationFeeData._feeFromJson(json['application_fee']),
      digitizationFee:
          DigitizationFeeData._feeFromJson(json['digitization_fee']),
      regenerationFee:
          DigitizationFeeData._feeFromJson(json['regeneration_fee']),
      currency: json['currency'] as String? ?? '',
      localGovernment: json['local_government'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String?,
    );

Map<String, dynamic> _$DigitizationFeeDataToJson(
        DigitizationFeeData instance) =>
    <String, dynamic>{
      'application_fee':
          DigitizationFeeData._feeToJson(instance.applicationFee),
      'digitization_fee':
          DigitizationFeeData._feeToJson(instance.digitizationFee),
      'regeneration_fee':
          DigitizationFeeData._feeToJson(instance.regenerationFee),
      'currency': instance.currency,
      'local_government': instance.localGovernment,
      'last_updated_by': instance.lastUpdatedBy,
    };

DigitizationApplicationData _$DigitizationApplicationDataFromJson(
        Map<String, dynamic> json) =>
    DigitizationApplicationData(
      userData: DigitizationApplicationData._userDataFromJson(json['data']),
      fee: DigitizationFeeData.fromJson(json['fee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DigitizationApplicationDataToJson(
        DigitizationApplicationData instance) =>
    <String, dynamic>{
      'data': DigitizationApplicationData._userDataToJson(instance.userData),
      'fee': instance.fee,
    };

DigitizationApplicationResponse _$DigitizationApplicationResponseFromJson(
        Map<String, dynamic> json) =>
    DigitizationApplicationResponse(
      message: json['message'] as String,
      data: DigitizationApplicationData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DigitizationApplicationResponseToJson(
        DigitizationApplicationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
