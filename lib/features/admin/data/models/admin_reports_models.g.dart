// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reports_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricCards _$MetricCardsFromJson(Map<String, dynamic> json) => MetricCards(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalRequests: (json['total_requests'] as num).toInt(),
      approvalRate: (json['approval_rate'] as num).toDouble(),
      averageProcessingDays: (json['average_processing_days'] as num).toDouble(),
    );

Map<String, dynamic> _$MetricCardsToJson(MetricCards instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'total_requests': instance.totalRequests,
      'approval_rate': instance.approvalRate,
      'average_processing_days': instance.averageProcessingDays,
    };

StatusDistribution _$StatusDistributionFromJson(Map<String, dynamic> json) =>
    StatusDistribution(
      approved: (json['approved'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
    );

Map<String, dynamic> _$StatusDistributionToJson(StatusDistribution instance) =>
    <String, dynamic>{
      'approved': instance.approved,
      'pending': instance.pending,
      'rejected': instance.rejected,
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

MonthlyBreakdown _$MonthlyBreakdownFromJson(Map<String, dynamic> json) =>
    MonthlyBreakdown(
      certificate: (json['certificate'] as List<dynamic>)
          .map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      digitizations: (json['digitizations'] as List<dynamic>)
          .map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonthlyBreakdownToJson(MonthlyBreakdown instance) =>
    <String, dynamic>{
      'certificate': instance.certificate,
      'digitizations': instance.digitizations,
    };

AdminReportsData _$AdminReportsDataFromJson(Map<String, dynamic> json) =>
    AdminReportsData(
      metricCards: MetricCards.fromJson(
          json['metric_cards'] as Map<String, dynamic>),
      statusDistribution: StatusDistribution.fromJson(
          json['status_distribution'] as Map<String, dynamic>),
      monthlyBreakdown: MonthlyBreakdown.fromJson(
          json['monthly_breakdown'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminReportsDataToJson(AdminReportsData instance) =>
    <String, dynamic>{
      'metric_cards': instance.metricCards,
      'status_distribution': instance.statusDistribution,
      'monthly_breakdown': instance.monthlyBreakdown,
    };

AdminReportsResponse _$AdminReportsResponseFromJson(
        Map<String, dynamic> json) =>
    AdminReportsResponse(
      message: json['message'] as String,
      data: AdminReportsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminReportsResponseToJson(
        AdminReportsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

