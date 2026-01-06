import 'package:json_annotation/json_annotation.dart';

part 'admin_reports_models.g.dart';

@JsonSerializable()
class MetricCards {
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @JsonKey(name: 'total_requests')
  final int totalRequests;
  @JsonKey(name: 'approval_rate')
  final double approvalRate;
  @JsonKey(name: 'average_processing_days')
  final double averageProcessingDays;

  const MetricCards({
    required this.totalRevenue,
    required this.totalRequests,
    required this.approvalRate,
    required this.averageProcessingDays,
  });

  factory MetricCards.fromJson(Map<String, dynamic> json) =>
      _$MetricCardsFromJson(json);

  Map<String, dynamic> toJson() => _$MetricCardsToJson(this);
}

@JsonSerializable()
class StatusDistribution {
  final int approved;
  final int pending;
  final int rejected;

  const StatusDistribution({
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  factory StatusDistribution.fromJson(Map<String, dynamic> json) =>
      _$StatusDistributionFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDistributionToJson(this);
}

@JsonSerializable()
class MonthlyData {
  final String month;
  final int total;

  const MonthlyData({
    required this.month,
    required this.total,
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) =>
      _$MonthlyDataFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyDataToJson(this);
}

@JsonSerializable()
class MonthlyBreakdown {
  final List<MonthlyData> certificate;
  final List<MonthlyData> digitizations;

  const MonthlyBreakdown({
    required this.certificate,
    required this.digitizations,
  });

  factory MonthlyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$MonthlyBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyBreakdownToJson(this);
}

@JsonSerializable()
class AdminReportsData {
  @JsonKey(name: 'metric_cards')
  final MetricCards metricCards;
  @JsonKey(name: 'status_distribution')
  final StatusDistribution statusDistribution;
  @JsonKey(name: 'monthly_breakdown')
  final MonthlyBreakdown monthlyBreakdown;

  const AdminReportsData({
    required this.metricCards,
    required this.statusDistribution,
    required this.monthlyBreakdown,
  });

  factory AdminReportsData.fromJson(Map<String, dynamic> json) =>
      _$AdminReportsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportsDataToJson(this);
}

@JsonSerializable()
class AdminReportsResponse {
  final String message;
  final AdminReportsData data;

  const AdminReportsResponse({
    required this.message,
    required this.data,
  });

  factory AdminReportsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminReportsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportsResponseToJson(this);
}
