import 'package:json_annotation/json_annotation.dart';

part 'dashboard_models.g.dart';

@JsonSerializable()
class MetricCard {
  final int? value;
  final String? trend;
  @JsonKey(name: 'percent_change')
  final double? percentChange;

  const MetricCard({
    this.value,
    this.trend,
    this.percentChange,
  });

  factory MetricCard.fromJson(Map<String, dynamic> json) =>
      _$MetricCardFromJson(json);

  Map<String, dynamic> toJson() => _$MetricCardToJson(this);
}

@JsonSerializable()
class MetricCards {
  @JsonKey(name: 'certificates_issued')
  final MetricCard certificatesIssued;
  @JsonKey(name: 'active_lgs')
  final MetricCard activeLgs;
  @JsonKey(name: 'total_revenue')
  final MetricCard? totalRevenue;
  @JsonKey(name: 'total_applications')
  final MetricCard totalApplications;

  const MetricCards({
    required this.certificatesIssued,
    required this.activeLgs,
    this.totalRevenue,
    required this.totalApplications,
  });

  factory MetricCards.fromJson(Map<String, dynamic> json) =>
      _$MetricCardsFromJson(json);

  Map<String, dynamic> toJson() => _$MetricCardsToJson(this);
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
class DashboardData {
  @JsonKey(name: 'metric_cards')
  final MetricCards metricCards;
  @JsonKey(name: 'monthly_applications')
  final List<MonthlyData> monthlyApplications;
  @JsonKey(name: 'monthly_revenue')
  final List<MonthlyData> monthlyRevenue;
  @JsonKey(name: 'active_lgas')
  final int activeLgas;

  const DashboardData({
    required this.metricCards,
    required this.monthlyApplications,
    required this.monthlyRevenue,
    required this.activeLgas,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

@JsonSerializable()
class DashboardResponse {
  final String message;
  final DashboardData data;

  const DashboardResponse({
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}

