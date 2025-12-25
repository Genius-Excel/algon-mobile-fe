// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      lastLogin: json['last_login'] as String?,
      isSuperuser: json['is_superuser'] as bool,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isStaff: json['is_staff'] as bool,
      isActive: json['is_active'] as bool,
      dateJoined: json['date_joined'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      profileImage: json['profile_image'] as String?,
      alternativeNumber: json['alternative_number'] as String?,
      emailVerified: json['email_verified'] as bool,
      nin: json['nin'] as String?,
      accountStatus: json['account_status'] as String,
      role: json['role'] as String,
      groups: json['groups'] as List<dynamic>,
      userPermissions: json['user_permissions'] as List<dynamic>,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'last_login': instance.lastLogin,
      'is_superuser': instance.isSuperuser,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_staff': instance.isStaff,
      'is_active': instance.isActive,
      'date_joined': instance.dateJoined,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'profile_image': instance.profileImage,
      'alternative_number': instance.alternativeNumber,
      'email_verified': instance.emailVerified,
      'nin': instance.nin,
      'account_status': instance.accountStatus,
      'role': instance.role,
      'groups': instance.groups,
      'user_permissions': instance.userPermissions,
    };

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      message: json['message'] as String,
      data: UserProfile.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
        UserProfileResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
