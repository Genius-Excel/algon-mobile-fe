import 'package:json_annotation/json_annotation.dart';

part 'invite_lg_admin_models.g.dart';

@JsonSerializable()
class InviteLGAdminRequest {
  final String state;
  @JsonKey(name: 'lga')
  final String lga;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;

  const InviteLGAdminRequest({
    required this.state,
    required this.lga,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() => _$InviteLGAdminRequestToJson(this);

  factory InviteLGAdminRequest.fromJson(Map<String, dynamic> json) =>
      _$InviteLGAdminRequestFromJson(json);
}

@JsonSerializable()
class InvitedLGAdminData {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  final String role;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;

  const InvitedLGAdminData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.emailVerified,
  });

  factory InvitedLGAdminData.fromJson(Map<String, dynamic> json) =>
      _$InvitedLGAdminDataFromJson(json);

  Map<String, dynamic> toJson() => _$InvitedLGAdminDataToJson(this);
}

@JsonSerializable()
class InviteLGAdminResponse {
  final String message;
  @JsonKey(name: 'email_status')
  final String? emailStatus;
  final List<InvitedLGAdminData> data;

  const InviteLGAdminResponse({
    required this.message,
    this.emailStatus,
    required this.data,
  });

  factory InviteLGAdminResponse.fromJson(Map<String, dynamic> json) =>
      _$InviteLGAdminResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InviteLGAdminResponseToJson(this);
}
