// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricCard _$MetricCardFromJson(Map<String, dynamic> json) => MetricCard(
      value: (json['value'] as num?)?.toInt(),
      trend: json['trend'] as String?,
      percentChange: (json['percent_change'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MetricCardToJson(MetricCard instance) =>
    <String, dynamic>{
      'value': instance.value,
      'trend': instance.trend,
      'percent_change': instance.percentChange,
    };

MetricCards _$MetricCardsFromJson(Map<String, dynamic> json) => MetricCards(
      certificatesIssued: MetricCard.fromJson(
          json['certificates_issued'] as Map<String, dynamic>),
      activeLgs:
          MetricCard.fromJson(json['active_lgs'] as Map<String, dynamic>),
      totalRevenue: json['total_revenue'] == null
          ? null
          : MetricCard.fromJson(json['total_revenue'] as Map<String, dynamic>),
      totalApplications: MetricCard.fromJson(
          json['total_applications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetricCardsToJson(MetricCards instance) =>
    <String, dynamic>{
      'certificates_issued': instance.certificatesIssued,
      'active_lgs': instance.activeLgs,
      'total_revenue': instance.totalRevenue,
      'total_applications': instance.totalApplications,
    };

MonthlyData _$MonthlyDataFromJson(Map<String, dynamic> json) => MonthlyData(
      month: json['month'] as String,
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyDataToJson(MonthlyData instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total': instance.total,
    };

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      metricCards:
          MetricCards.fromJson(json['metric_cards'] as Map<String, dynamic>),
      monthlyApplications: (json['monthly_applications'] as List<dynamic>)
          .map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlyRevenue: (json['monthly_revenue'] as List<dynamic>)
          .map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeLgas: (json['active_lgas'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'metric_cards': instance.metricCards,
      'monthly_applications': instance.monthlyApplications,
      'monthly_revenue': instance.monthlyRevenue,
      'active_lgas': instance.activeLgas,
    };

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      message: json['message'] as String,
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
