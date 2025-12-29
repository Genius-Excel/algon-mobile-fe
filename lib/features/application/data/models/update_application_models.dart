// import 'package:json_annotation/json_annotation.dart';

// part 'update_application_models.g.dart';

// @JsonSerializable()
// class UpdateApplicationRequest {
//   final String? residentialAddress;
//   final String? landmark;
//   final List<ExtraField>? extraFields;

//   const UpdateApplicationRequest({
//     this.residentialAddress,
//     this.landmark,
//     this.extraFields,
//   });

//   Map<String, dynamic> toJson() => _$UpdateApplicationRequestToJson(this);

//   factory UpdateApplicationRequest.fromJson(Map<String, dynamic> json) =>
//       _$UpdateApplicationRequestFromJson(json);
// }

// @JsonSerializable()
// class ExtraField {
//   @JsonKey(name: 'field_name')
//   final String fieldName;
//   @JsonKey(name: 'field_value')
//   final String fieldValue;
//   @JsonKey(name: 'field_id')
//   final String fieldId;

//   const ExtraField({
//     required this.fieldName,
//     required this.fieldValue,
//     required this.fieldId,
//   });

//   factory ExtraField.fromJson(Map<String, dynamic> json) =>
//       _$ExtraFieldFromJson(json);

//   Map<String, dynamic> toJson() => _$ExtraFieldToJson(this);
// }

// @JsonSerializable()
// class FeeData {
//   @JsonKey(name: 'application_fee')
//   final num? applicationFee;
//   @JsonKey(name: 'digitization_fee')
//   final num? digitizationFee;
//   @JsonKey(name: 'regeneration_fee')
//   final num? regenerationFee;
//   final String currency;
//   @JsonKey(name: 'local_government')
//   final String? localGovernment;
//   @JsonKey(name: 'last_updated_by')
//   final String? lastUpdatedBy;

//   const FeeData({
//     this.applicationFee,
//     this.digitizationFee,
//     this.regenerationFee,
//     required this.currency,
//     this.localGovernment,
//     this.lastUpdatedBy,
//   });

//   factory FeeData.fromJson(Map<String, dynamic> json) =>
//       _$FeeDataFromJson(json);

//   Map<String, dynamic> toJson() => _$FeeDataToJson(this);
// }

// @JsonSerializable()
// class UpdateApplicationData {
//   final FeeData fee;
//   @JsonKey(name: 'verification_fee')
//   final num? verificationFee;
//   @JsonKey(name: 'application_id')
//   final String applicationId;

//   const UpdateApplicationData({
//     required this.fee,
//     this.verificationFee,
//     required this.applicationId,
//   });

//   factory UpdateApplicationData.fromJson(Map<String, dynamic> json) =>
//       _$UpdateApplicationDataFromJson(json);

//   Map<String, dynamic> toJson() => _$UpdateApplicationDataToJson(this);
// }

// @JsonSerializable()
// class UpdateApplicationResponse {
//   final String message;
//   final UpdateApplicationData data;

//   const UpdateApplicationResponse({
//     required this.message,
//     required this.data,
//   });

//   factory UpdateApplicationResponse.fromJson(Map<String, dynamic> json) =>
//       _$UpdateApplicationResponseFromJson(json);

//   Map<String, dynamic> toJson() => _$UpdateApplicationResponseToJson(this);
// }


import 'package:json_annotation/json_annotation.dart';

part 'update_application_models.g.dart';

@JsonSerializable()
class UpdateApplicationRequest {
  final String? residentialAddress;
  final String? landmark;
  final List<ExtraField>? extraFields;

  const UpdateApplicationRequest({
    this.residentialAddress,
    this.landmark,
    this.extraFields,
  });

  Map<String, dynamic> toJson() => _$UpdateApplicationRequestToJson(this);

  factory UpdateApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationRequestFromJson(json);
}

@JsonSerializable()
class ExtraField {
  @JsonKey(name: 'field_name')
  final String fieldName;
  @JsonKey(name: 'field_value')
  final String fieldValue;
  @JsonKey(name: 'field_id')
  final String fieldId;

  const ExtraField({
    required this.fieldName,
    required this.fieldValue,
    required this.fieldId,
  });

  factory ExtraField.fromJson(Map<String, dynamic> json) =>
      _$ExtraFieldFromJson(json);

  Map<String, dynamic> toJson() => _$ExtraFieldToJson(this);
}

@JsonSerializable()
class FeeData {
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

  const FeeData({
    this.applicationFee,
    this.digitizationFee,
    this.regenerationFee,
    required this.currency,
    this.localGovernment,
    this.lastUpdatedBy,
  });

  factory FeeData.fromJson(Map<String, dynamic> json) =>
      _$FeeDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeeDataToJson(this);

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
class UpdateApplicationData {
  final FeeData fee;
  @JsonKey(name: 'verification_fee', fromJson: _feeFromJson, toJson: _feeToJson)
  final num? verificationFee;
  @JsonKey(name: 'application_id')
  final String applicationId;

  const UpdateApplicationData({
    required this.fee,
    this.verificationFee,
    required this.applicationId,
  });

  factory UpdateApplicationData.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApplicationDataToJson(this);

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
class UpdateApplicationResponse {
  final String message;
  final UpdateApplicationData data;

  const UpdateApplicationResponse({
    required this.message,
    required this.data,
  });

  factory UpdateApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateApplicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApplicationResponseToJson(this);
}