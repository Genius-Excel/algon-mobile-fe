import 'package:json_annotation/json_annotation.dart';

part 'user_profile_models.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  @JsonKey(name: 'last_login')
  final String? lastLogin;
  @JsonKey(name: 'is_superuser')
  final bool isSuperuser;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'is_staff')
  final bool isStaff;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'date_joined')
  final String dateJoined;
  final String email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'alternative_number')
  final String? alternativeNumber;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  final String? nin;
  @JsonKey(name: 'account_status')
  final String accountStatus;
  final String role;
  final List<dynamic> groups;
  @JsonKey(name: 'user_permissions')
  final List<dynamic> userPermissions;

  const UserProfile({
    required this.id,
    this.lastLogin,
    required this.isSuperuser,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.alternativeNumber,
    required this.emailVerified,
    this.nin,
    required this.accountStatus,
    required this.role,
    required this.groups,
    required this.userPermissions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String get fullName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '${firstName.trim()} ${lastName.trim()}'.trim();
    }
    return username;
  }
}

@JsonSerializable()
class UserProfileResponse {
  final String message;
  final UserProfile data;

  const UserProfileResponse({
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}
