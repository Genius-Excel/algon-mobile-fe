import 'package:json_annotation/json_annotation.dart';

part 'application_list_models.g.dart';

@JsonSerializable()
class StateData {
  final String id;
  final String name;

  const StateData({
    required this.id,
    required this.name,
  });

  factory StateData.fromJson(Map<String, dynamic> json) =>
      _$StateDataFromJson(json);

  Map<String, dynamic> toJson() => _$StateDataToJson(this);
}

@JsonSerializable()
class LocalGovernmentData {
  final String id;
  final String name;

  const LocalGovernmentData({
    required this.id,
    required this.name,
  });

  factory LocalGovernmentData.fromJson(Map<String, dynamic> json) =>
      _$LocalGovernmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocalGovernmentDataToJson(this);
}

@JsonSerializable()
class ApplicationItem {
  final String id;
  final String nin;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String email;
  final String village;
  @JsonKey(name: 'residential_address')
  final String? residentialAddress;
  final String? landmark;
  @JsonKey(name: 'letter_from_traditional_ruler')
  final String? letterFromTraditionalRuler;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  @JsonKey(name: 'nin_slip')
  final String? ninSlip;
  @JsonKey(name: 'application_status')
  final String applicationStatus;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  final String? remarks;
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final String applicant;
  final StateData state;
  @JsonKey(name: 'local_government')
  final LocalGovernmentData localGovernment;
  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  const ApplicationItem({
    required this.id,
    required this.nin,
    required this.fullName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.village,
    this.residentialAddress,
    this.landmark,
    this.letterFromTraditionalRuler,
    this.profilePhoto,
    this.ninSlip,
    required this.applicationStatus,
    required this.paymentStatus,
    this.remarks,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.applicant,
    required this.state,
    required this.localGovernment,
    this.approvedBy,
  });

  factory ApplicationItem.fromJson(Map<String, dynamic> json) =>
      _$ApplicationItemFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationItemToJson(this);
}

@JsonSerializable()
class ApplicationListData {
  final int count;
  final String? next;
  final String? previous;
  final List<ApplicationItem> results;

  const ApplicationListData({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ApplicationListData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationListDataToJson(this);
}

@JsonSerializable()
class ApplicationListResponse {
  final String message;
  final ApplicationListData data;

  const ApplicationListResponse({
    required this.message,
    required this.data,
  });

  factory ApplicationListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationListResponseToJson(this);
}

