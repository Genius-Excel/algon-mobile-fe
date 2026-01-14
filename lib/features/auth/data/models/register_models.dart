import 'package:json_annotation/json_annotation.dart';

part 'register_models.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String password;
  final String? nin;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  const RegisterRequest({
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.nin,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  final List<RegisterData> data;

  const RegisterResponse({
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterData {
  @JsonKey(name: 'user_id')
  final String userId;
  final String email;
  final String role;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  const RegisterData({
    required this.userId,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
