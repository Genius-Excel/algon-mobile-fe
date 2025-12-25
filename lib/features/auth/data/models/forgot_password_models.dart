import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_models.g.dart';

@JsonSerializable()
class ResetEmailRequest {
  final String email;
  @JsonKey(name: 'device_type')
  final String deviceType;

  const ResetEmailRequest({
    required this.email,
    this.deviceType = 'mobile',
  });

  Map<String, dynamic> toJson() => _$ResetEmailRequestToJson(this);
}

@JsonSerializable()
class ResetEmailResponse {
  final String message;
  @JsonKey(name: 'email_status')
  final String emailStatus;

  const ResetEmailResponse({
    required this.message,
    required this.emailStatus,
  });

  factory ResetEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetEmailResponseToJson(this);
}

@JsonSerializable()
class PasswordResetRequest {
  final String email;
  final String otp;
  final String password1;
  final String password2;

  const PasswordResetRequest({
    required this.email,
    required this.otp,
    required this.password1,
    required this.password2,
  });

  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}

@JsonSerializable()
class PasswordResetResponse {
  final String message;

  const PasswordResetResponse({
    required this.message,
  });

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetResponseToJson(this);
}

