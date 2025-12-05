// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lga_fee_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LGAFeeData _$LGAFeeDataFromJson(Map<String, dynamic> json) => LGAFeeData(
      id: json['id'] as String,
      applicationFee: json['application_fee'] as String,
      digitizationFee: json['digitization_fee'] as String,
      regenerationFee: json['regeneration_fee'] as String,
      currency: json['currency'] as String,
      updatedAt: json['updated_at'] as String,
      localGovernment: json['local_government'] as String,
      lastUpdatedBy: json['last_updated_by'] as String?,
      state: json['state'] as String,
    );

Map<String, dynamic> _$LGAFeeDataToJson(LGAFeeData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_fee': instance.applicationFee,
      'digitization_fee': instance.digitizationFee,
      'regeneration_fee': instance.regenerationFee,
      'currency': instance.currency,
      'updated_at': instance.updatedAt,
      'local_government': instance.localGovernment,
      'last_updated_by': instance.lastUpdatedBy,
      'state': instance.state,
    };

LGAFeeResponse _$LGAFeeResponseFromJson(Map<String, dynamic> json) =>
    LGAFeeResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => LGAFeeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LGAFeeResponseToJson(LGAFeeResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

CreateLGAFeeRequest _$CreateLGAFeeRequestFromJson(Map<String, dynamic> json) =>
    CreateLGAFeeRequest(
      applicationFee: (json['application_fee'] as num).toDouble(),
      digitizationFee: (json['digitization_fee'] as num).toDouble(),
      regenerationFee: (json['regeneration_fee'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateLGAFeeRequestToJson(
        CreateLGAFeeRequest instance) =>
    <String, dynamic>{
      'application_fee': instance.applicationFee,
      'digitization_fee': instance.digitizationFee,
      'regeneration_fee': instance.regenerationFee,
    };
