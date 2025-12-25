// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetEmailRequest _$ResetEmailRequestFromJson(Map<String, dynamic> json) =>
    ResetEmailRequest(
      email: json['email'] as String,
      deviceType: json['device_type'] as String? ?? 'mobile',
    );

Map<String, dynamic> _$ResetEmailRequestToJson(ResetEmailRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'device_type': instance.deviceType,
    };

ResetEmailResponse _$ResetEmailResponseFromJson(Map<String, dynamic> json) =>
    ResetEmailResponse(
      message: json['message'] as String,
      emailStatus: json['email_status'] as String,
    );

Map<String, dynamic> _$ResetEmailResponseToJson(ResetEmailResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'email_status': instance.emailStatus,
    };

PasswordResetRequest _$PasswordResetRequestFromJson(
        Map<String, dynamic> json) =>
    PasswordResetRequest(
      email: json['email'] as String,
      otp: json['otp'] as String,
      password1: json['password1'] as String,
      password2: json['password2'] as String,
    );

Map<String, dynamic> _$PasswordResetRequestToJson(
        PasswordResetRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
      'password1': instance.password1,
      'password2': instance.password2,
    };

PasswordResetResponse _$PasswordResetResponseFromJson(
        Map<String, dynamic> json) =>
    PasswordResetResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$PasswordResetResponseToJson(
        PasswordResetResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
