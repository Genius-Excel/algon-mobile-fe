// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_list_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateData _$StateDataFromJson(Map<String, dynamic> json) => StateData(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StateDataToJson(StateData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

LocalGovernmentData _$LocalGovernmentDataFromJson(Map<String, dynamic> json) =>
    LocalGovernmentData(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocalGovernmentDataToJson(
        LocalGovernmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ApplicationItem _$ApplicationItemFromJson(Map<String, dynamic> json) =>
    ApplicationItem(
      id: json['id'] as String,
      nin: json['nin'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: json['date_of_birth'] as String?,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      village: json['village'] as String?,
      residentialAddress: json['residential_address'] as String?,
      landmark: json['landmark'] as String?,
      letterFromTraditionalRuler:
          json['letter_from_traditional_ruler'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      ninSlip: json['nin_slip'] as String?,
      applicationStatus: json['application_status'] as String,
      paymentStatus: json['payment_status'] as String,
      remarks: json['remarks'] as String?,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      applicant: json['applicant'] as String,
      state: StateData.fromJson(json['state'] as Map<String, dynamic>),
      localGovernment: LocalGovernmentData.fromJson(
          json['local_government'] as Map<String, dynamic>),
      approvedBy: ApplicationItem._approvedByFromJson(json['approved_by']),
    );

Map<String, dynamic> _$ApplicationItemToJson(ApplicationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nin': instance.nin,
      'full_name': instance.fullName,
      'date_of_birth': instance.dateOfBirth,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'village': instance.village,
      'residential_address': instance.residentialAddress,
      'landmark': instance.landmark,
      'letter_from_traditional_ruler': instance.letterFromTraditionalRuler,
      'profile_photo': instance.profilePhoto,
      'nin_slip': instance.ninSlip,
      'application_status': instance.applicationStatus,
      'payment_status': instance.paymentStatus,
      'remarks': instance.remarks,
      'approved_at': instance.approvedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'applicant': instance.applicant,
      'state': instance.state,
      'local_government': instance.localGovernment,
      'approved_by': ApplicationItem._approvedByToJson(instance.approvedBy),
    };

ApplicationListData _$ApplicationListDataFromJson(Map<String, dynamic> json) =>
    ApplicationListData(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => ApplicationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApplicationListDataToJson(
        ApplicationListData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

ApplicationListResponse _$ApplicationListResponseFromJson(
        Map<String, dynamic> json) =>
    ApplicationListResponse(
      message: json['message'] as String,
      data: ApplicationListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationListResponseToJson(
        ApplicationListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

ApplicationDetailsResponse _$ApplicationDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    ApplicationDetailsResponse(
      message: json['message'] as String,
      data: ApplicationItem.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationDetailsResponseToJson(
        ApplicationDetailsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
