// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_application_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateApplicationRequest _$CertificateApplicationRequestFromJson(
        Map<String, dynamic> json) =>
    CertificateApplicationRequest(
      dateOfBirth: json['dateOfBirth'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      landmark: json['landmark'] as String?,
      localGovernment: json['localGovernment'] as String,
      phoneNumber: json['phoneNumber'] as String,
      state: json['state'] as String,
      village: json['village'] as String,
      nin: json['nin'] as String,
    );

Map<String, dynamic> _$CertificateApplicationRequestToJson(
        CertificateApplicationRequest instance) =>
    <String, dynamic>{
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'fullName': instance.fullName,
      'landmark': instance.landmark,
      'localGovernment': instance.localGovernment,
      'phoneNumber': instance.phoneNumber,
      'state': instance.state,
      'village': instance.village,
      'nin': instance.nin,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      fullName: json['fullName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      state: json['state'] as String,
      localGovernment: json['localGovernment'] as String,
      village: json['village'] as String,
      nin: json['nin'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'dateOfBirth': instance.dateOfBirth,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'state': instance.state,
      'localGovernment': instance.localGovernment,
      'village': instance.village,
      'nin': instance.nin,
    };

CertificateApplicationData _$CertificateApplicationDataFromJson(
        Map<String, dynamic> json) =>
    CertificateApplicationData(
      userData: UserData.fromJson(json['userData'] as Map<String, dynamic>),
      extraFields: json['extraFields'] as List<dynamic>,
      applicationId: json['application_id'] as String,
    );

Map<String, dynamic> _$CertificateApplicationDataToJson(
        CertificateApplicationData instance) =>
    <String, dynamic>{
      'userData': instance.userData,
      'extraFields': instance.extraFields,
      'application_id': instance.applicationId,
    };

CertificateApplicationResponse _$CertificateApplicationResponseFromJson(
        Map<String, dynamic> json) =>
    CertificateApplicationResponse(
      message: json['message'] as String,
      data: CertificateApplicationData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CertificateApplicationResponseToJson(
        CertificateApplicationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
