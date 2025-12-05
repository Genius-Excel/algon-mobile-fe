// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalGovernment _$LocalGovernmentFromJson(Map<String, dynamic> json) =>
    LocalGovernment(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocalGovernmentToJson(LocalGovernment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

StateData _$StateDataFromJson(Map<String, dynamic> json) => StateData(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      localGovernments: (json['local_governtments'] as List<dynamic>)
          .map((e) => LocalGovernment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StateDataToJson(StateData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'local_governtments': instance.localGovernments,
    };

StatesResponse _$StatesResponseFromJson(Map<String, dynamic> json) =>
    StatesResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => StateData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatesResponseToJson(StatesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
