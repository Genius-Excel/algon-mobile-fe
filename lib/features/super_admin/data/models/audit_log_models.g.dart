// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLogItem _$AuditLogItemFromJson(Map<String, dynamic> json) => AuditLogItem(
      id: json['id'] as String,
      actionType: json['action_type'] as String,
      tableName: json['table_name'] as String?,
      recordId: json['record_id'] as String?,
      changes: json['changes'],
      description: json['description'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: json['created_at'] as String,
      user: json['user'] as String?,
    );

Map<String, dynamic> _$AuditLogItemToJson(AuditLogItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action_type': instance.actionType,
      'table_name': instance.tableName,
      'record_id': instance.recordId,
      'changes': instance.changes,
      'description': instance.description,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'created_at': instance.createdAt,
      'user': instance.user,
    };

AuditLogListData _$AuditLogListDataFromJson(Map<String, dynamic> json) =>
    AuditLogListData(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => AuditLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuditLogListDataToJson(AuditLogListData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

AuditLogListResponse _$AuditLogListResponseFromJson(
        Map<String, dynamic> json) =>
    AuditLogListResponse(
      message: json['message'] as String,
      data: AuditLogListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuditLogListResponseToJson(
        AuditLogListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
