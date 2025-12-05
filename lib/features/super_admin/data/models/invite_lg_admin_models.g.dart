// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_lg_admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteLGAdminRequest _$InviteLGAdminRequestFromJson(
        Map<String, dynamic> json) =>
    InviteLGAdminRequest(
      state: json['state'] as String,
      lga: json['lga'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$InviteLGAdminRequestToJson(
        InviteLGAdminRequest instance) =>
    <String, dynamic>{
      'state': instance.state,
      'lga': instance.lga,
      'full_name': instance.fullName,
      'email': instance.email,
    };

InvitedLGAdminData _$InvitedLGAdminDataFromJson(Map<String, dynamic> json) =>
    InvitedLGAdminData(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      emailVerified: json['email_verified'] as bool,
    );

Map<String, dynamic> _$InvitedLGAdminDataToJson(InvitedLGAdminData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'email_verified': instance.emailVerified,
    };

InviteLGAdminResponse _$InviteLGAdminResponseFromJson(
        Map<String, dynamic> json) =>
    InviteLGAdminResponse(
      message: json['message'] as String,
      emailStatus: json['email_status'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => InvitedLGAdminData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InviteLGAdminResponseToJson(
        InviteLGAdminResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'email_status': instance.emailStatus,
      'data': instance.data,
    };
