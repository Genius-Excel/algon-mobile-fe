// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lg_admin_list_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LGAdminListItem _$LGAdminListItemFromJson(Map<String, dynamic> json) =>
    LGAdminListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      stateId: json['state_id'] as String,
      localGovernment: json['local_government'] as String,
      localGovernmentId: json['local_government_id'] as String,
      adminName: json['admin_name'] as String?,
      adminEmail: json['admin_email'] as String?,
      adminId: json['admin_id'] as String?,
      applicationsCount: (json['applications_count'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$LGAdminListItemToJson(LGAdminListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'state': instance.state,
      'state_id': instance.stateId,
      'local_government': instance.localGovernment,
      'local_government_id': instance.localGovernmentId,
      'admin_name': instance.adminName,
      'admin_email': instance.adminEmail,
      'admin_id': instance.adminId,
      'applications_count': instance.applicationsCount,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

LGAdminListResponse _$LGAdminListResponseFromJson(Map<String, dynamic> json) =>
    LGAdminListResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => LGAdminListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LGAdminListResponseToJson(
        LGAdminListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'total_count': instance.totalCount,
    };
