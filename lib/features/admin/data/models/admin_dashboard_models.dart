import 'package:json_annotation/json_annotation.dart';

part 'admin_dashboard_models.g.dart';

@JsonSerializable()
class AdminMetricCard {
  final int value;
  final String? trend;
  @JsonKey(name: 'change_percent')
  final double? changePercent;

  const AdminMetricCard({
    required this.value,
    this.trend,
    this.changePercent,
  });

  factory AdminMetricCard.fromJson(Map<String, dynamic> json) =>
      _$AdminMetricCardFromJson(json);

  Map<String, dynamic> toJson() => _$AdminMetricCardToJson(this);
}

@JsonSerializable()
class AdminMetricCards {
  @JsonKey(name: 'pending_applications')
  final AdminMetricCard pendingApplications;
  @JsonKey(name: 'approved_certificates')
  final AdminMetricCard approvedCertificates;
  final AdminMetricCard rejected;
  @JsonKey(name: 'total_revenue')
  final AdminMetricCard totalRevenue;

  const AdminMetricCards({
    required this.pendingApplications,
    required this.approvedCertificates,
    required this.rejected,
    required this.totalRevenue,
  });

  factory AdminMetricCards.fromJson(Map<String, dynamic> json) =>
      _$AdminMetricCardsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminMetricCardsToJson(this);
}

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
class RecentApplication {
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
  @JsonKey(name: 'approved_by', fromJson: _approvedByFromJson, toJson: _approvedByToJson)
  final String? approvedBy;

  const RecentApplication({
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

  factory RecentApplication.fromJson(Map<String, dynamic> json) {
    // Create a copy to avoid mutating the original
    final jsonCopy = Map<String, dynamic>.from(json);
    
    // Remove application_type if present (not part of RecentApplication model)
    jsonCopy.remove('application_type');
    
    return _$RecentApplicationFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() => _$RecentApplicationToJson(this);
  
  static String? _approvedByFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map<String, dynamic>) {
      // Convert object to string (use ID or email)
      return json['id'] ?? json['email'];
    }
    return json.toString();
  }
  
  static dynamic _approvedByToJson(String? approvedBy) => approvedBy;
}

@JsonSerializable()
class AdminDashboardData {
  @JsonKey(name: 'metric_cards')
  final AdminMetricCards metricCards;
  @JsonKey(name: 'weekly_applications')
  final int weeklyApplications;
  @JsonKey(name: 'approval_statistics')
  final int approvalStatistics;
  @JsonKey(name: 'recent_applications')
  final List<RecentApplication> recentApplications;

  const AdminDashboardData({
    required this.metricCards,
    required this.weeklyApplications,
    required this.approvalStatistics,
    required this.recentApplications,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDashboardDataToJson(this);
}

@JsonSerializable()
class AdminDashboardResponse {
  final String message;
  final AdminDashboardData data;

  const AdminDashboardResponse({
    required this.message,
    required this.data,
  });

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDashboardResponseToJson(this);
}

