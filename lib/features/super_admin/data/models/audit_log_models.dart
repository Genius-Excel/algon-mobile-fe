import 'package:json_annotation/json_annotation.dart';

part 'audit_log_models.g.dart';

@JsonSerializable()
class AuditLogItem {
  final String id;
  @JsonKey(name: 'action_type')
  final String actionType;
  @JsonKey(name: 'table_name')
  final String? tableName;
  @JsonKey(name: 'record_id')
  final String? recordId;
  final dynamic changes; // Can be object, string, or null
  final String? description;
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String? user; // User ID

  const AuditLogItem({
    required this.id,
    required this.actionType,
    this.tableName,
    this.recordId,
    this.changes,
    this.description,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
    this.user,
  });

  factory AuditLogItem.fromJson(Map<String, dynamic> json) =>
      _$AuditLogItemFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogItemToJson(this);
}

@JsonSerializable()
class AuditLogListData {
  final int count;
  final String? next;
  final String? previous;
  final List<AuditLogItem> results;

  const AuditLogListData({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AuditLogListData.fromJson(Map<String, dynamic> json) =>
      _$AuditLogListDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogListDataToJson(this);
}

@JsonSerializable()
class AuditLogListResponse {
  final String message;
  final AuditLogListData data;

  const AuditLogListResponse({
    required this.message,
    required this.data,
  });

  factory AuditLogListResponse.fromJson(Map<String, dynamic> json) =>
      _$AuditLogListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogListResponseToJson(this);
}

