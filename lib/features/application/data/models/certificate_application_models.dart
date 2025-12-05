import 'package:json_annotation/json_annotation.dart';

part 'certificate_application_models.g.dart';

@JsonSerializable()
class CertificateApplicationRequest {
  final String dateOfBirth;
  final String email;
  final String fullName;
  final String? landmark;
  final String localGovernment;
  final String phoneNumber;
  final String state;
  final String village;
  final String nin;

  const CertificateApplicationRequest({
    required this.dateOfBirth,
    required this.email,
    required this.fullName,
    this.landmark,
    required this.localGovernment,
    required this.phoneNumber,
    required this.state,
    required this.village,
    required this.nin,
  });

  Map<String, dynamic> toJson() => _$CertificateApplicationRequestToJson(this);

  factory CertificateApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$CertificateApplicationRequestFromJson(json);
}

@JsonSerializable()
class UserData {
  final String fullName;
  final String dateOfBirth;
  final String phoneNumber;
  final String email;
  final String state;
  final String localGovernment;
  final String village;
  final String nin;

  const UserData({
    required this.fullName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.state,
    required this.localGovernment,
    required this.village,
    required this.nin,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class CertificateApplicationData {
  final UserData userData;
  final List<dynamic> extraFields;
  @JsonKey(name: 'application_id')
  final String applicationId;

  const CertificateApplicationData({
    required this.userData,
    required this.extraFields,
    required this.applicationId,
  });

  factory CertificateApplicationData.fromJson(Map<String, dynamic> json) =>
      _$CertificateApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateApplicationDataToJson(this);
}

@JsonSerializable()
class CertificateApplicationResponse {
  final String message;
  final CertificateApplicationData data;

  const CertificateApplicationResponse({
    required this.message,
    required this.data,
  });

  factory CertificateApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateApplicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateApplicationResponseToJson(this);
}

