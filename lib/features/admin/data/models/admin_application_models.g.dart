// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateApplicationStatusRequest _$UpdateApplicationStatusRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateApplicationStatusRequest(
      applicationType: json['application_type'] as String,
      action: json['action'] as String,
    );

Map<String, dynamic> _$UpdateApplicationStatusRequestToJson(
        UpdateApplicationStatusRequest instance) =>
    <String, dynamic>{
      'application_type': instance.applicationType,
      'action': instance.action,
    };

UpdateApplicationStatusResponse _$UpdateApplicationStatusResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateApplicationStatusResponse(
      message: json['message'] as String,
      data: UpdateApplicationStatusResponse._applicationItemFromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateApplicationStatusResponseToJson(
        UpdateApplicationStatusResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data':
          UpdateApplicationStatusResponse._applicationItemToJson(instance.data),
    };
