import 'package:json_annotation/json_annotation.dart';

part 'login_models.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@JsonSerializable()
class LoginResponse {
  final String message;
  @JsonKey(name: 'user_id')
  final String userId;
  final String role;
  @JsonKey(name: 'refresh-token')
  final String refreshToken;
  @JsonKey(name: 'access-token')
  final String accessToken;

  const LoginResponse({
    required this.message,
    required this.userId,
    required this.role,
    required this.refreshToken,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
