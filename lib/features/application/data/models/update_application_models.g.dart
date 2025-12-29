// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_application_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateApplicationRequest _$UpdateApplicationRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateApplicationRequest(
      residentialAddress: json['residentialAddress'] as String?,
      landmark: json['landmark'] as String?,
      extraFields: (json['extraFields'] as List<dynamic>?)
          ?.map((e) => ExtraField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateApplicationRequestToJson(
        UpdateApplicationRequest instance) =>
    <String, dynamic>{
      'residentialAddress': instance.residentialAddress,
      'landmark': instance.landmark,
      'extraFields': instance.extraFields,
    };

ExtraField _$ExtraFieldFromJson(Map<String, dynamic> json) => ExtraField(
      fieldName: json['field_name'] as String,
      fieldValue: json['field_value'] as String,
      fieldId: json['field_id'] as String,
    );

Map<String, dynamic> _$ExtraFieldToJson(ExtraField instance) =>
    <String, dynamic>{
      'field_name': instance.fieldName,
      'field_value': instance.fieldValue,
      'field_id': instance.fieldId,
    };

FeeData _$FeeDataFromJson(Map<String, dynamic> json) => FeeData(
      applicationFee: FeeData._feeFromJson(json['application_fee']),
      digitizationFee: FeeData._feeFromJson(json['digitization_fee']),
      regenerationFee: FeeData._feeFromJson(json['regeneration_fee']),
      currency: json['currency'] as String,
      localGovernment: json['local_government'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String?,
    );

Map<String, dynamic> _$FeeDataToJson(FeeData instance) => <String, dynamic>{
      'application_fee': FeeData._feeToJson(instance.applicationFee),
      'digitization_fee': FeeData._feeToJson(instance.digitizationFee),
      'regeneration_fee': FeeData._feeToJson(instance.regenerationFee),
      'currency': instance.currency,
      'local_government': instance.localGovernment,
      'last_updated_by': instance.lastUpdatedBy,
    };

UpdateApplicationData _$UpdateApplicationDataFromJson(
        Map<String, dynamic> json) =>
    UpdateApplicationData(
      fee: FeeData.fromJson(json['fee'] as Map<String, dynamic>),
      verificationFee:
          UpdateApplicationData._feeFromJson(json['verification_fee']),
      applicationId: json['application_id'] as String,
    );

Map<String, dynamic> _$UpdateApplicationDataToJson(
        UpdateApplicationData instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'verification_fee':
          UpdateApplicationData._feeToJson(instance.verificationFee),
      'application_id': instance.applicationId,
    };

UpdateApplicationResponse _$UpdateApplicationResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateApplicationResponse(
      message: json['message'] as String,
      data:
          UpdateApplicationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateApplicationResponseToJson(
        UpdateApplicationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
