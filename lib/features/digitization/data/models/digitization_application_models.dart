import 'package:json_annotation/json_annotation.dart';

part 'digitization_application_models.g.dart';

@JsonSerializable()
class DigitizationApplicationRequest {
  final String nin;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String state;
  @JsonKey(name: 'local_government')
  final String localGovernment;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'certificate_reference_number')
  final String? certificateReferenceNumber;

  const DigitizationApplicationRequest({
    required this.nin,
    required this.email,
    required this.fullName,
    required this.state,
    required this.localGovernment,
    required this.phoneNumber,
    this.certificateReferenceNumber,
  });

  Map<String, dynamic> toJson() => _$DigitizationApplicationRequestToJson(this);

  factory DigitizationApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$DigitizationApplicationRequestFromJson(json);
}

@JsonSerializable()
class DigitizationUserData {
  final String id;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String state;
  @JsonKey(name: 'local_government')
  final String localGovernment;
  @JsonKey(name: 'certificate_reference_number')
  final String? certificateReferenceNumber;
  final String nin;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'verification_status')
  final String verificationStatus;
  @JsonKey(name: 'reviewed_at')
  final String? reviewedAt;
  final String? remarks;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;

  const DigitizationUserData({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.state,
    required this.localGovernment,
    this.certificateReferenceNumber,
    required this.nin,
    required this.fullName,
    required this.paymentStatus,
    required this.verificationStatus,
    this.reviewedAt,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedBy,
  });

  factory DigitizationUserData.fromJson(Map<String, dynamic> json) =>
      _$DigitizationUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$DigitizationUserDataToJson(this);
}

@JsonSerializable()
class DigitizationFeeData {
  @JsonKey(name: 'application_fee', fromJson: _feeFromJson, toJson: _feeToJson)
  final num? applicationFee;
  @JsonKey(name: 'digitization_fee', fromJson: _feeFromJson, toJson: _feeToJson)
  final num? digitizationFee;
  @JsonKey(name: 'regeneration_fee', fromJson: _feeFromJson, toJson: _feeToJson)
  final num? regenerationFee;
  final String currency;
  @JsonKey(name: 'local_government')
  final String? localGovernment;
  @JsonKey(name: 'last_updated_by')
  final String? lastUpdatedBy;

  const DigitizationFeeData({
    this.applicationFee,
    this.digitizationFee,
    this.regenerationFee,
    this.currency = '',
    this.localGovernment,
    this.lastUpdatedBy,
  });

  factory DigitizationFeeData.fromJson(Map<String, dynamic> json) =>
      _$DigitizationFeeDataFromJson(json);

  Map<String, dynamic> toJson() => _$DigitizationFeeDataToJson(this);

  static num? _feeFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  static dynamic _feeToJson(num? value) => value;
}

@JsonSerializable()
class DigitizationApplicationData {
  @JsonKey(name: 'data', fromJson: _userDataFromJson, toJson: _userDataToJson)
  final DigitizationUserData userData;
  final DigitizationFeeData fee;

  const DigitizationApplicationData({
    required this.userData,
    required this.fee,
  });

  factory DigitizationApplicationData.fromJson(Map<String, dynamic> json) =>
      _$DigitizationApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$DigitizationApplicationDataToJson(this);

  static DigitizationUserData _userDataFromJson(dynamic json) {
    if (json == null) {
      throw ArgumentError('Expected user data but got null');
    }
    if (json is Map<String, dynamic>) {
      return DigitizationUserData.fromJson(json);
    }
    throw ArgumentError(
        'Expected Map<String, dynamic> but got ${json.runtimeType}');
  }

  static Map<String, dynamic> _userDataToJson(DigitizationUserData userData) =>
      userData.toJson();
}

@JsonSerializable()
class DigitizationApplicationResponse {
  final String message;
  final DigitizationApplicationData data;

  const DigitizationApplicationResponse({
    required this.message,
    required this.data,
  });

  factory DigitizationApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$DigitizationApplicationResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DigitizationApplicationResponseToJson(this);
}
