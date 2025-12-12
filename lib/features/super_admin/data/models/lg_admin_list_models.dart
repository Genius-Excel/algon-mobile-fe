import 'package:json_annotation/json_annotation.dart';

part 'lg_admin_list_models.g.dart';

@JsonSerializable()
class LGAdminListItem {
  final String id;
  final String name;
  final String state;
  @JsonKey(name: 'state_id')
  final String stateId;
  @JsonKey(name: 'local_government')
  final String localGovernment;
  @JsonKey(name: 'local_government_id')
  final String localGovernmentId;
  @JsonKey(name: 'admin_name')
  final String? adminName;
  @JsonKey(name: 'admin_email')
  final String? adminEmail;
  @JsonKey(name: 'admin_id')
  final String? adminId;
  @JsonKey(name: 'applications_count')
  final int? applicationsCount;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const LGAdminListItem({
    required this.id,
    required this.name,
    required this.state,
    required this.stateId,
    required this.localGovernment,
    required this.localGovernmentId,
    this.adminName,
    this.adminEmail,
    this.adminId,
    this.applicationsCount,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LGAdminListItem.fromJson(Map<String, dynamic> json) =>
      _$LGAdminListItemFromJson(json);

  Map<String, dynamic> toJson() => _$LGAdminListItemToJson(this);
}

@JsonSerializable()
class LGAdminListResponse {
  final String message;
  final List<LGAdminListItem> data;
  @JsonKey(name: 'total_count')
  final int? totalCount;

  const LGAdminListResponse({
    required this.message,
    required this.data,
    this.totalCount,
  });

  factory LGAdminListResponse.fromJson(Map<String, dynamic> json) =>
      _$LGAdminListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LGAdminListResponseToJson(this);
}

